import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:forum/model/admin_model/kelolaabsenadmin_model/kelolaabsenadmin_model.dart';

class KelolaAbsensiController extends GetxController {
  /// Menyimpan data kelas sebagai List<KelasModel>
  var kelasData = <KelasModel>[].obs;

  /// Menandakan apakah sedang loading atau tidak
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKelasData();
  }

  /// Fungsi untuk mengambil data kelas dari API
  Future<void> fetchKelasData() async {
    const String url = "https://absen.randijourney.my.id/api/v1/kelas";
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Asumsikan struktur API: { "data": [ { "id": ..., "nama_kelas": ..., "nama_user": ... }, ... ] }
        final List<dynamic> listKelas = data['data'] ?? [];
        // Parsing setiap item ke dalam instance KelasModel
        final List<KelasModel> parsedKelas =
            listKelas.map((item) => KelasModel.fromJson(item)).toList();
        kelasData.value = parsedKelas;
      } else {
        throw Exception(
            "Failed to load kelas data (status: ${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data kelas: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        colorText: const Color.fromARGB(255, 255, 255, 255),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
