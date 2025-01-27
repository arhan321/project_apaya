import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileGuruController extends GetxController {
  final nameController = TextEditingController(); // Nama
  final nipGuruController = TextEditingController(); // NIP Guru
  final agamaController = TextEditingController(); // Agama
  final umurController = TextEditingController(); // Umur
  final waliKelasController = TextEditingController(); // Wali Kelas
  final roleController = TextEditingController(text: 'Guru'); // Role
  final birthDateController = TextEditingController(); // Tanggal Lahir

  File? imageFile;
  String? imageUrl;
  String? userId;
  String? authToken;

  List<String> waliKelasList = []; // Daftar wali_kelas dari API

  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchWaliKelasData();
    _loadProfileData();
  }

  Future<void> fetchWaliKelasData() async {
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
        final waliKelasData = response.data['data'] as List<dynamic>;
        waliKelasList =
            waliKelasData.map((k) => k['nama_kelas'] as String).toList();

        // Jika waliKelasList kosong, gunakan default value dari controller
        if (waliKelasList.isEmpty) {
          waliKelasList.add(waliKelasController.text);
        }

        update(); // Refresh UI
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data wali_kelas.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil data wali_kelas.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('Error fetching wali_kelas: $e');
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
        nipGuruController.text = data['nip_guru']?.toString() ?? '';
        agamaController.text = data['agama'] ?? '';
        umurController.text = data['umur'] ?? '';
        waliKelasController.text = data['wali_kelas'] ?? '';
        birthDateController.text = data['tanggal_lahir'] ?? '';
        userId = data['id']?.toString();
        imageUrl = data['image_url'];
        update();
      } else {
        Get.snackbar('Error', 'Failed to fetch profile data.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred while loading profile data.',
          snackPosition: SnackPosition.BOTTOM);
      debugPrint('Error: $e');
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
      Get.snackbar('Error', 'Failed to pick image',
          snackPosition: SnackPosition.BOTTOM);
      debugPrint('Error: $e');
    }
  }

  Future<void> uploadPhoto() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error', 'Session expired or missing information.',
          snackPosition: SnackPosition.BOTTOM);
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
          Get.snackbar('Success', 'Photo uploaded successfully.',
              snackPosition: SnackPosition.BOTTOM);
          update();
        } else {
          Get.snackbar('Error', 'Failed to upload photo.',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', 'No photo selected.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while uploading photo.',
          snackPosition: SnackPosition.BOTTOM);
      debugPrint('Error: $e');
    }
  }

  Future<void> updateProfile() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error', 'Session expired or missing information.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId';

    try {
      Map<String, dynamic> data = {
        if (nameController.text.isNotEmpty) 'name': nameController.text,
        if (nipGuruController.text.isNotEmpty)
          'nip_guru': nipGuruController.text,
        if (agamaController.text.isNotEmpty) 'agama': agamaController.text,
        if (umurController.text.isNotEmpty) 'umur': umurController.text,
        if (waliKelasController.text.isNotEmpty)
          'wali_kelas': waliKelasController.text,
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
        Get.snackbar('Success', 'Profile updated successfully.',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update profile.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating your profile.',
          snackPosition: SnackPosition.BOTTOM);
      debugPrint('Error: $e');
    }
  }
}
