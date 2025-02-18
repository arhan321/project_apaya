import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ListAkunGuruController extends GetxController {
  final Dio _dio = Dio();

  /// Gunakan Rx (reaktif) agar dapat di-*listen* di view
  var akunGuru = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAkunGuru();
  }

  /// Method untuk mengambil data akun guru
  Future<void> fetchAkunGuru() async {
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
        // Pastikan `data` adalah List agar bisa di-map
        if (data is List) {
          final filteredData = data
              .where((item) => item['role']?.toLowerCase() == 'guru')
              .map((item) => {
                    'id': item['id'].toString(),
                    'foto': item['image_url'] ?? '',
                    'nama': item['name'] ?? 'Nama tidak tersedia',
                    'email': item['email'] ?? 'Email tidak tersedia',
                    'password': '********',
                    'role': item['role'] ?? '',
                  })
              .toList();

          akunGuru.assignAll(filteredData);
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

  /// Method untuk menghapus akun guru
  Future<void> deleteAkunGuru(String id) async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account/$id';

    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        akunGuru.removeWhere((akun) => akun['id'] == id);
        Get.snackbar(
          'Berhasil',
          'Akun berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal menghapus akun',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus akun',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
