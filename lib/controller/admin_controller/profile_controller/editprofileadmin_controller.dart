import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileAdminController extends GetxController {
  // final nameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();
  final birthDateController = TextEditingController(); // Untuk tanggal lahir
  final usernameController = TextEditingController(); // Tambahkan ini
  final passwordController = TextEditingController(); // Tambahkan ini

  File? imageFile;
  String? imageUrl;
  String? userId;
  String? authToken;

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
        'https://absen.randijourney.my.id/auth/me',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        usernameController.text = data['name'] ?? ''; // Inisialisasi
        roleController.text = data['role'] ?? 'Administrator';
        birthDateController.text = data['tanggal_lahir'] ?? '';
        userId = data['id']?.toString();
        imageUrl = data['image_url'];
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred while loading profile data.');
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> uploadPhoto() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error', 'Session expired or missing information.');
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId/foto';

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
      Get.snackbar('Error', 'Session expired or missing information.');
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId';

    try {
      Map<String, dynamic> data = {
        if (usernameController.text.isNotEmpty)
          'username': usernameController.text,
        if (emailController.text.isNotEmpty) 'email': emailController.text,
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,
        if (birthDateController.text.isNotEmpty)
          'tanggal_lahir': birthDateController.text,
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
