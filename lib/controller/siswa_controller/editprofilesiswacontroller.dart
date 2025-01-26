import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileSiswaController extends GetxController {
  final nameController = TextEditingController();
  final classController = TextEditingController(); // Kelas
  final numberController = TextEditingController(); // Nomor absen
  final birthDateController = TextEditingController(); // Tanggal lahir
  final agamaController = TextEditingController(); // Agama
  final nisnController = TextEditingController(); // NISN
  final umurController = TextEditingController(); // Umur

  File? imageFile;
  String? imageUrl;
  String? userId;
  String? authToken;
  String errorMessage = '';
  List<String> kelasList = []; // Daftar kelas dari API

  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchKelasData();
    _loadProfileData();
  }

  Future<void> fetchKelasData() async {
    try {
      final response = await _dio.get(
        'https://absen.randijourney.my.id/api/v1/kelas',
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final kelasData = response.data['data'] as List<dynamic>;
        kelasList = kelasData.map((k) => k['nama_kelas'] as String).toList();

        // Jika kelasList kosong, ambil data dari pengguna
        if (kelasList.isEmpty) {
          final prefs = await SharedPreferences.getInstance();
          String? userKelas = prefs.getString('kelas');
          if (userKelas != null && userKelas.isNotEmpty) {
            kelasList.add(userKelas);
            classController.text = userKelas;
          }
        }

        update(); // Refresh UI
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data kelas.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil data kelas.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Error fetching kelas: $e');
    }
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
        nameController.text = data['name'] ?? '';
        classController.text = data['kelas'] ?? '';
        numberController.text = data['nomor_absen']?.toString() ?? '';
        birthDateController.text = data['tanggal_lahir'] ?? '';
        agamaController.text = data['agama'] ?? '';
        nisnController.text = data['nisn']?.toString() ?? '';
        umurController.text = data['umur'] ?? '';
        userId = data['id']?.toString();
        imageUrl = data['image_url'];
        update(); // Refresh UI
      } else {
        errorMessage = 'Failed to fetch profile data. Please try again later.';
        debugPrint('Error: ${response.data}');
      }
    } catch (e) {
      errorMessage = 'Error occurred while loading profile data';
      debugPrint('Error occurred in _loadProfileData: $e');
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
      debugPrint('Error occurred in pickImage: $e');
    }
  }

  Future<void> uploadPhoto() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
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
          debugPrint('Error: ${response.data}');
        }
      } else {
        Get.snackbar('Error', 'No photo selected.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while uploading photo.');
      debugPrint('Error occurred in uploadPhoto: $e');
    }
  }

  Future<void> updateProfile() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId';

    try {
      Map<String, dynamic> data = {
        if (nameController.text.isNotEmpty) 'name': nameController.text,
        if (classController.text.isNotEmpty) 'kelas': classController.text,
        if (numberController.text.isNotEmpty)
          'nomor_absen': numberController.text,
        if (agamaController.text.isNotEmpty) 'agama': agamaController.text,
        if (nisnController.text.isNotEmpty) 'nisn': nisnController.text,
        if (umurController.text.isNotEmpty) 'umur': umurController.text,
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
        debugPrint('Error: ${response.data}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating your profile.');
      debugPrint('Error occurred in updateProfile: $e');
    }
  }
}
