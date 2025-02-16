import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DaftarKelasController extends GetxController {
  /// Data kelas yang kita simpan dalam bentuk RxList agar bisa diobservasi
  var kelasData = <dynamic>[].obs;

  /// Menunjukkan apakah sedang loading atau tidak
  var isLoading = true.obs;

  /// Dipanggil otomatis oleh Getx ketika controller pertama kali diinisialisasi
  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data saat pertama kali controller dibuat
  }

  /// Fetch data dari API
  Future<void> fetchData() async {
    final url = Uri.parse("https://absen.randijourney.my.id/api/v1/kelas");
    isLoading.value = true;

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        /// Update kelasData dengan data dari server
        kelasData.value = data['data'] ?? [];
      } else {
        throw Exception("Gagal memuat data kelas.");
      }
    } catch (e) {
      /// Tampilkan snackbar error
      Get.snackbar(
        'Kesalahan',
        'Gagal mengambil data kelas: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      /// Selesai loading, set isLoading=false
      isLoading.value = false;
    }
  }

  /// Hapus kelas dari API
  Future<void> deleteKelas(int id) async {
    final url = Uri.parse("https://absen.randijourney.my.id/api/v1/kelas/$id");

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        /// Hapus item di kelasData
        kelasData.removeWhere((kelas) => kelas['id'] == id);

        Get.snackbar(
          'Berhasil',
          'Kelas berhasil dihapus!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Gagal menghapus kelas.");
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus kelas. $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
