import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ListAkunOrtuController extends GetxController {
  final Dio _dio = Dio();

  // Buat variabel reaktif untuk menyimpan data dan status
  var akunOrtu = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAkunOrtu();
  }

  /// Memuat data akun orang tua
  Future<void> fetchAkunOrtu() async {
    isLoading.value = true;
    errorMessage.value = '';

    const String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          final listOrtu = data
              .where((item) => item['role']?.toLowerCase() == 'orang_tua')
              .map((item) => {
                    'id': item['id'].toString(),
                    'foto': item['image_url'] ?? '',
                    'nama': item['name'] ?? 'Nama tidak tersedia',
                    'email': item['email'] ?? 'Email tidak tersedia',
                    'password': '********',
                    'role': item['role'] ?? '',
                  })
              .toList();

          akunOrtu.assignAll(listOrtu);
        }
        isLoading.value = false;
      } else {
        errorMessage.value =
            'Gagal memuat data. Status Code: ${response.statusCode}';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data: $e';
      isLoading.value = false;
    }
  }

  /// Menghapus akun orang tua
  Future<void> deleteAkunOrtu(String id) async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account/$id';

    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        akunOrtu.removeWhere((akun) => akun['id'] == id);
        Get.snackbar(
          'Berhasil',
          'Akun berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 76, 175, 80),
          colorText: const Color.fromARGB(255, 255, 255, 255),
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal menghapus akun',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 244, 67, 54),
          colorText: const Color.fromARGB(255, 255, 255, 255),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus akun',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        colorText: const Color.fromARGB(255, 255, 255, 255),
      );
    }
  }
}
