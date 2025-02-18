import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../model/admin_model/kelolaakun_model/listakunadmin_model.dart';

class ListAkunAdminController extends GetxController {
  final Dio dioClient = Dio();

  /// Menyimpan list akun admin sebagai List<AdminAkunModel>
  var akunAdmin = <AdminAkunModel>[].obs;

  /// Menyimpan state loading
  var isLoading = true.obs;

  /// Menyimpan pesan error (jika ada)
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAkunAdmin();
  }

  /// Mengambil data akun admin dari server
  Future<void> fetchAkunAdmin() async {
    isLoading.value = true;
    errorMessage.value = '';

    const String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      final response = await dioClient.get(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          // Filter hanya akun dengan role 'admin'
          final filteredList = data
              .where((item) => (item['role'] ?? '').toLowerCase() == 'admin')
              .toList();

          // Mapping ke dalam model AdminAkunModel
          final List<AdminAkunModel> parsedData = filteredList
              .map((item) => AdminAkunModel.fromJson(item))
              .toList();

          akunAdmin.value = parsedData;
        }
      } else {
        errorMessage.value =
            'Gagal memuat data. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fungsi untuk menghapus akun
  Future<void> deleteAkun(String id) async {
    const String baseUrl = 'https://absen.randijourney.my.id/api/v1/account/';
    try {
      final response = await dioClient.delete('$baseUrl$id');

      if (response.statusCode == 200) {
        // Hapus akun dari list berdasarkan properti id pada model
        akunAdmin.removeWhere((item) => item.id == id);

        Get.snackbar(
          'Sukses',
          'Akun berhasil dihapus.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Tidak dapat menghapus akun.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus akun: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
