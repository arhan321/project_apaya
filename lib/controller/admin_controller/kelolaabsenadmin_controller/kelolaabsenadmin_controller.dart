import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class KelolaAbsensiController extends GetxController {
  /// Menyimpan data kelas
  var kelasData = <dynamic>[].obs;

  /// Menandakan apakah kita sedang loading atau tidak
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKelasData();
  }

  /// Fungsi untuk fetch data kelas
  Future<void> fetchKelasData() async {
    const String url = "https://absen.randijourney.my.id/api/v1/kelas";
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Update kelasData dengan data dari API
        kelasData.value = data['data'] ?? [];
      } else {
        throw Exception("Failed to load kelas data");
      }
    } catch (e) {
      // Tampilkan snackbar error
      Get.snackbar(
        'Error',
        'Gagal mengambil data kelas: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        colorText: const Color.fromARGB(255, 255, 255, 255),
      );
    } finally {
      // Selesai loading
      isLoading.value = false;
    }
  }
}
