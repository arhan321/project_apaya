import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileOrtuController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final umurController = TextEditingController();
  String? agama;
  List<String> agamaOptions = [
    'islam',
    'kristen',
    'katolik',
    'hindu',
    'budha',
    'konghucu'
  ];
  List<String> waliMuridList = [];
  String? selectedWaliMurid;

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
    fetchWaliMuridData();
    _loadProfileData();
  }

  Future<void> fetchWaliMuridData() async {
    debugPrint('Fetching wali murid data...');
    try {
      final response = await _dio.get(
        'https://absen.randijourney.my.id/api/v1/account',
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          waliMuridList = data
              .where((user) =>
                  user is Map<String, dynamic> &&
                  user.containsKey('name') &&
                  user.containsKey('role') &&
                  user['role'] == 'siswa') // Filter hanya dengan role "siswa"
              .map((user) => user['name']?.toString() ?? 'Unknown')
              .toList();

          debugPrint('Wali murid list (siswa): $waliMuridList');
          update(); // Refresh UI
        } else {
          debugPrint('Invalid data format: $data');
          Get.snackbar(
            'Error',
            'Gagal mengambil data wali murid. Format data tidak valid.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        debugPrint('Error response: ${response.data}');
        Get.snackbar(
          'Error',
          'Gagal mengambil data wali murid.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error fetching wali murid: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil data wali murid.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadProfileData() async {
    debugPrint('Loading profile data...');
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('authToken');

      if (authToken == null) {
        debugPrint('Auth token is null. Redirecting to login.');
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
        debugPrint('Profile data loaded successfully.');
        final data = response.data;
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        umurController.text = data['umur']?.toString() ?? '';
        agama = data['agama'];
        userId = data['id']?.toString();
        imageUrl = data['image_url'];
        update();
      } else {
        debugPrint('Failed to fetch profile data: ${response.data}');
        errorMessage = 'Failed to fetch profile data. Please try again later.';
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
      errorMessage = 'Error occurred while loading profile data';
    }
  }

  void setAgama(String? value) {
    debugPrint('Setting agama: $value');
    agama = value;
    update();
  }

  void setWaliMurid(String? value) {
    debugPrint('Setting wali murid: $value');
    selectedWaliMurid = value;
    update();
  }

  Future<void> pickImage() async {
    debugPrint('Picking image...');
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        debugPrint('Image picked: ${imageFile!.path}');
        update();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> uploadPhoto() async {
    debugPrint('Uploading photo...');
    if (authToken == null || userId == null) {
      debugPrint('Auth token or user ID is null.');
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId/foto';

    try {
      if (imageFile != null) {
        String fileName = imageFile!.path.split('/').last;
        debugPrint('Preparing to upload file: $fileName');

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
          debugPrint('Photo uploaded successfully.');
          imageUrl = response.data['image_url'];
          Get.snackbar('Success', 'Photo uploaded successfully.');
          update();
        } else {
          debugPrint('Failed to upload photo: ${response.data}');
          Get.snackbar('Error', 'Failed to upload photo.');
        }
      } else {
        debugPrint('No photo selected.');
        Get.snackbar('Error', 'No photo selected.');
      }
    } catch (e) {
      debugPrint('Error uploading photo: $e');
      Get.snackbar('Error', 'An error occurred while uploading photo.');
    }
  }

  Future<void> updateProfile() async {
    debugPrint('Updating profile...');
    if (authToken == null || userId == null) {
      debugPrint('Auth token or user ID is null.');
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId';

    try {
      Map<String, dynamic> data = {
        if (nameController.text.isNotEmpty) 'name': nameController.text,
        if (emailController.text.isNotEmpty) 'email': emailController.text,
        if (umurController.text.isNotEmpty) 'umur': umurController.text,
        if (agama != null) 'agama': agama,
        if (selectedWaliMurid != null) 'wali_murid': selectedWaliMurid,
      };

      debugPrint('Sending update data: $data');
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
        debugPrint('Profile updated successfully.');
        Get.snackbar('Success', 'Profile updated successfully.');
      } else {
        debugPrint('Failed to update profile: ${response.data}');
        Get.snackbar('Error', 'Failed to update profile.');
      }
    } catch (e) {
      debugPrint('Error updating profile: $e');
      Get.snackbar('Error', 'An error occurred while updating your profile.');
    }
  }
}
