import 'dart:async'; // Import Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../model/orangtua_model/mainpageortu_model.dart';

class MainPageOrtuController extends GetxController {
  var userName = 'Guest'.obs;
  var userEmail = ''.obs;
  var userImageUrl = Rxn<String>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var classList = <Map<String, dynamic>>[].obs; // Daftar kelas

  // --- Tambahan untuk notifikasi lonceng ---
  var lastChangedClassIndex =
      (-1).obs; // Menyimpan indeks kelas yang terakhir berubah
  var previousData =
      <Map<String, dynamic>>[].obs; // Untuk mendeteksi perubahan data
  Timer? _timer;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    fetchClassData(); // Memuat data kelas saat init
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
        final List<Map<String, dynamic>> newData =
            data.map((e) => e as Map<String, dynamic>).toList();

        // Cek perubahan data (misalnya jumlah siswa pada setiap kelas)
        _checkForChanges(newData);

        classList.value = newData; // Simpan data kelas
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

  void _checkForChanges(List<Map<String, dynamic>> newData) {
    bool hasChanges = false;
    int changedIndex = -1;

    // Hanya jalankan jika previousData tidak kosong
    if (previousData.isNotEmpty) {
      // Jika jumlah kelas berubah
      if (newData.length != previousData.length) {
        hasChanges = true;
        changedIndex =
            newData.length - 1; // Asumsikan perubahan di kelas terakhir
      } else {
        // Cek setiap kelas
        for (int i = 0; i < newData.length; i++) {
          final newClass = newData[i];
          final prevClass = previousData[i];

          if (newClass.containsKey('siswa') && prevClass.containsKey('siswa')) {
            final List<dynamic> newSiswa = newClass['siswa'] == null
                ? []
                : (newClass['siswa'] is String
                    ? List.from(json.decode(newClass['siswa']))
                    : newClass['siswa']);
            final List<dynamic> prevSiswa = prevClass['siswa'] == null
                ? []
                : (prevClass['siswa'] is String
                    ? List.from(json.decode(prevClass['siswa']))
                    : prevClass['siswa']);

            if (newSiswa.length != prevSiswa.length) {
              hasChanges = true;
              changedIndex =
                  i; // Menyimpan indeks kelas yang mengalami perubahan
              break;
            }
          }
        }
      }
    }

    if (hasChanges) {
      lastChangedClassIndex.value = changedIndex;
      _showChangeNotification();
      _cancelTimer(); // Kita reset timer jika ada perubahan
    } else {
      // Jika tidak ada perubahan, mulai timer 10 detik
      _startTimer();
    }

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

  // ---- Bagian Timer untuk menghilangkan notifikasi setelah 10 detik ----
  void _startTimer() {
    _cancelTimer();
    _timer = Timer(Duration(seconds: 10), () {
      lastChangedClassIndex.value = -1;
    });
  }

  void _cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }
  // ----------------------------------------------------

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
