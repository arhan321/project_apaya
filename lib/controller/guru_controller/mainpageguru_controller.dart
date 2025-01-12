import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPageGuruController extends GetxController {
  var userName = 'Guest'.obs;
  var userEmail = ''.obs;
  var kelas = ''.obs;
  var waliKelas = ''.obs;
  var userImageUrl = Rxn<String>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserData(); // Memastikan data diperbarui setiap kali MainPage dibuka
  }

  Future<void> fetchUserData() async {
    const String url = 'https://absen.randijourney.my.id/auth/me';

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences
          .getInstance(); // Pindahkan inisialisasi ke sini
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        errorMessage.value = 'Token tidak ditemukan. Silakan login ulang.';
        Get.offAllNamed('/welcome');
        return;
      }

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        userName.value = data['name'] ?? 'Nama tidak tersedia';
        userEmail.value = data['email'] ?? 'Email tidak tersedia';
        kelas.value = data['kelas'] ?? 'Kelas tidak diketahui';
        waliKelas.value = data['wali_kelas'] ?? 'Tidak ada wali kelas';
        userImageUrl.value = data['image_url'];
      } else {
        errorMessage.value = 'Gagal mengambil data: ${response.data}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    const String url = 'https://absen.randijourney.my.id/api/v1/account/logout';

    try {
      final prefs = await SharedPreferences
          .getInstance(); // Pindahkan inisialisasi ke sini
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        await prefs.clear();
        _showLogoutSuccessMessage();
        return;
      }

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        _showLogoutSuccessMessage();
      } else {
        await prefs.clear();
        _showLogoutSuccessMessage();
      }
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _showLogoutSuccessMessage();
    }
  }

  void _showLogoutSuccessMessage() {
    Get.snackbar(
      'Berhasil',
      'Logout berhasil!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );
    Get.offAllNamed('/welcome');
  }
}
