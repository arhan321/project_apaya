import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../model/admin_model/kelolaakun_model/listakunortu_model.dart';

class ListAkunOrtuController extends GetxController {
  final Dio _dio = Dio();

  /// Menyimpan list akun orang tua sebagai List<OrtuAkunModel>
  var akunOrtu = <OrtuAkunModel>[].obs;

  /// Menyimpan state loading
  var isLoading = true.obs;

  /// Menyimpan pesan error (jika ada)
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAkunOrtu();
  }

  /// Memuat data akun orang tua dari API
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
          // Filter hanya akun dengan role "orang_tua"
          final filteredData = data
              .where((item) => item['role']?.toLowerCase() == 'orang_tua')
              .toList();

          // Mapping data ke model OrtuAkunModel
          final List<OrtuAkunModel> parsedData =
              filteredData.map((item) => OrtuAkunModel.fromJson(item)).toList();

          akunOrtu.assignAll(parsedData);
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

  /// Fungsi untuk menghapus akun orang tua berdasarkan id
  Future<void> deleteAkunOrtu(String id) async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account/$id';

    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // Hapus akun berdasarkan properti id pada model
        akunOrtu.removeWhere((akun) => akun.id == id);

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
