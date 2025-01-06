import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ListAbsenAdminController extends GetxController {
  var siswaAbsen = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  int? selectedClassId;
  String namaKelas = 'Kelas';
  String waliKelas = 'Wali Kelas';

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments ?? {};
    selectedClassId = arguments['id'];
    namaKelas = arguments['namaKelas'] ?? 'Kelas';
    waliKelas = arguments['waliKelas'] ?? 'Wali Kelas';

    if (selectedClassId == null) {
      Get.snackbar(
        'Error',
        'ID kelas tidak ditemukan. Harap pilih kelas yang valid.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (selectedClassId == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://absen.djncloud.my.id/api/v1/kelas'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final kelasData = responseData['data'] as List<dynamic>;

        // Cari kelas berdasarkan ID
        final kelas = kelasData.firstWhere(
          (k) => k['id'] == selectedClassId,
          orElse: () => null,
        );

        if (kelas != null) {
          // Decode ulang siswa yang masih berupa string
          final siswaRawJson = kelas['siswa'] as String;
          final siswaList = json.decode(siswaRawJson) as List<dynamic>;

          print('Siswa data: $siswaList');

          // Map data siswa
          siswaAbsen.value = siswaList.map((siswa) {
            return {
              'name': siswa['nama'],
              'nomor_absen': siswa['nomor_absen'],
              'status': siswa['keterangan'],
              'time': siswa['jam_absen'],
              'color': _getStatusColor(siswa['keterangan']),
            };
          }).toList();
        } else {
          print('Kelas dengan ID $selectedClassId tidak ditemukan.');
          Get.snackbar(
            'Error',
            'Data kelas tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print('Error: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Gagal mengambil data absensi. Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil data absensi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'sakit':
        return Colors.blue;
      case 'izin':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
