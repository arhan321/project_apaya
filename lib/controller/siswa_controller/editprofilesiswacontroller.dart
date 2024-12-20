import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileSiswaController extends GetxController {
  final nameController = TextEditingController();
  final classController = TextEditingController(text: 'Kelas 6A');
  final numberController = TextEditingController();
  final userIdController = TextEditingController();
  File? imageFile;
  String? imageUrl;
  String? userId;
  String? authToken;
  String errorMessage = '';

  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('authToken');

      if (authToken == null) {
        Get.snackbar('Session Expired', 'Please log in again.',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.get(
        'https://absen.djncloud.my.id/auth/me',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        nameController.text = data['name'] ?? '';
        numberController.text = data['nomor_absen']?.toString() ?? '';
        userIdController.text = data['id']?.toString() ?? '';
        userId = data['id']?.toString();
        imageUrl = data['image_url'];
        update(); // Refresh UI
      } else {
        errorMessage = 'Failed to fetch profile data. Please try again later.';
      }
    } catch (e) {
      errorMessage = 'Error occurred while loading profile data';
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        update(); // Refresh UI
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> uploadPhoto() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url =
        'https://absen.djncloud.my.id/api/v1/account/$userId/foto';

    try {
      if (imageFile != null) {
        String fileName = imageFile!.path.split('/').last;

        dio.FormData formData = dio.FormData.fromMap({
          'photo': await dio.MultipartFile.fromFile(
            imageFile!.path,
            filename: fileName,
          ),
        });

        final response = await _dio.post(
          url,
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $authToken',
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        if (response.statusCode == 200) {
          imageUrl = response.data['image_url'];
          Get.snackbar('Success', 'Photo uploaded successfully.');
          update();
        } else {
          Get.snackbar('Error', 'Failed to upload photo.');
        }
      } else {
        Get.snackbar('Error', 'No photo selected.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while uploading photo.');
    }
  }

  Future<void> updateProfile() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url = 'https://absen.djncloud.my.id/api/v1/account/$userId';

    try {
      Map<String, dynamic> data = {
        if (nameController.text.isNotEmpty) 'name': nameController.text,
        if (numberController.text.isNotEmpty)
          'nomor_absen': numberController.text,
      };

      final response = await _dio.put(
        url,
        data: data,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully.');
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating your profile.');
    }
  }
}
