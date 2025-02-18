import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../model/admin_model/kelolaakun_model/listakunsiswa_model.dart';

class ListAkunSiswaController extends GetxController {
  final Dio _dio = Dio();

  /// Data siswa disimpan sebagai List<SiswaAkunModel> agar lebih terstruktur
  var akunSiswa = <SiswaAkunModel>[].obs;

  /// Status loading
  var isLoading = true.obs;

  /// Pesan error
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAkunSiswa();
  }

  /// Mengambil data akun siswa dari API
  Future<void> fetchAkunSiswa() async {
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
          // Filter data untuk role "siswa"
          final listSiswa = data
              .where((item) => item['role']?.toLowerCase() == 'siswa')
              .toList();

          // Mapping tiap item ke dalam model SiswaAkunModel
          final List<SiswaAkunModel> parsedData =
              listSiswa.map((item) => SiswaAkunModel.fromJson(item)).toList();

          akunSiswa.assignAll(parsedData);
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

  /// Menghapus akun siswa berdasarkan id
  Future<void> deleteAkunSiswa(String id) async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account/$id';

    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // Hapus akun dari list berdasarkan properti id pada model
        akunSiswa.removeWhere((akun) => akun.id == id);

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
        'Terjadi kesalahan saat menghapus akun: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        colorText: const Color.fromARGB(255, 255, 255, 255),
      );
    }
  }
}
