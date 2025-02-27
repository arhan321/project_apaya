import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Untuk penggunaan json.decode

class MainPageGuruController extends GetxController {
  var userName = 'Guest'.obs;
  var userEmail = ''.obs;
  var userRole = ''.obs;
  var userImageUrl = Rxn<String>();
  var kelasList = <Map<String, dynamic>>[].obs; // List kelas yang diampu guru
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final Dio _dio = Dio();
  var previousData = <Map<String, dynamic>>[]
      .obs; // Data kelas sebelumnya untuk mendeteksi perubahan

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchKelasData(); // Muat data kelas saat pertama kali diinisialisasi
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
        userRole.value = data['role'] ?? 'Role tidak diketahui';
        userImageUrl.value = data['image_url'];
      } else {
        errorMessage.value =
            'Gagal mengambil data pengguna. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data pengguna.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchKelasData() async {
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
        final List<Map<String, dynamic>> newData =
            data.map((e) => e as Map<String, dynamic>).toList();

        // Cek perbedaan data siswa
        _checkForChanges(newData);

        kelasList.value = newData; // Simpan data kelas
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

  // Membandingkan data sebelumnya dengan data terbaru
  void _checkForChanges(List<Map<String, dynamic>> newData) {
    for (int i = 0; i < newData.length; i++) {
      if (i < previousData.length) {
        final currentClass = newData[i];
        final previousClass = previousData[i];

        final List<dynamic> currentSiswa = currentClass['siswa'] == null
            ? []
            : List.from(json.decode(currentClass['siswa']));
        final List<dynamic> previousSiswa = previousClass['siswa'] == null
            ? []
            : List.from(json.decode(previousClass['siswa']));

        if (currentSiswa.length != previousSiswa.length) {
          // Jika ada perubahan jumlah siswa
          _showChangeNotification();
        }
      }
    }

    // Update previous data
    previousData.value = newData;
  }

  void _showChangeNotification() {
    Get.snackbar(
      'Pembaruan Data',
      'Ada perubahan pada data kelas.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orangeAccent,
      colorText: Colors.white,
    );
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
