import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/orangtua_model/mainpageortu_model.dart';

class MainPageOrtuController extends GetxController {
  var userName = 'Guest'.obs;
  var userEmail = ''.obs;
  var userImageUrl = Rxn<String>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var classList = <Map<String, dynamic>>[].obs; // Tambahkan untuk daftar kelas

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchClassData(); // Tambahkan untuk memuat data kelas saat init
  }

  Future<void> fetchUserData() async {
    const String url = 'https://absen.randijourney.my.id/auth/me';

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
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

  Future<void> fetchClassData() async {
    const String url = 'https://absen.randijourney.my.id/api/v1/kelas/';

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final prefs = await SharedPreferences.getInstance();
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
        final data = response.data['data'] as List;
        classList.value = data
            .map((e) => e as Map<String, dynamic>)
            .toList(); // Simpan data kelas
      } else {
        errorMessage.value =
            'Gagal mengambil data kelas. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data kelas.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    const String url = 'https://absen.randijourney.my.id/api/v1/account/logout';

    try {
      final prefs = await SharedPreferences.getInstance();
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
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());
      _showLogoutSuccessMessage();
    }
  }

  void _showLogoutSuccessMessage() {
    Get.snackbar(
      'Success',
      'Logout berhasil!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.greenAccent,
      colorText: Colors.white,
    );
    Get.offAllNamed('/welcome');
  }
}
