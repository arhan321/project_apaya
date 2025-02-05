import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ListAbsenAdminController extends GetxController {
  var siswaAbsen = <Map<String, dynamic>>[].obs;
  var filteredSiswaAbsen = <Map<String, dynamic>>[].obs; // Filtered data
  var isLoading = true.obs;
  int? selectedClassId;
  String namaKelas = 'Kelas';
  String waliKelas = 'Wali Kelas';
  var selectedFilter = 'All'.obs; // Filter selection

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments ?? {};
    print('Arguments received: $arguments');

    selectedClassId = arguments['id'] as int?;
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
      return;
    }
    fetchData();
  }

  // Fetch data from the API
  Future<void> fetchData() async {
    if (selectedClassId == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://absen.randijourney.my.id/api/v1/kelas'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final kelasData = responseData['data'] as List<dynamic>;

        final kelas = kelasData.firstWhere(
          (k) => k['id'] == selectedClassId,
          orElse: () => null,
        );

        if (kelas != null) {
          final siswaRawJson = kelas['siswa'] as String?;
          if (siswaRawJson == null || siswaRawJson.isEmpty) {
            siswaAbsen.value = [];
            filteredSiswaAbsen.value = []; // Clear filtered list as well
            return;
          }

          final siswaList = json.decode(siswaRawJson) as List<dynamic>;
          siswaAbsen.value = siswaList.map((siswa) {
            return {
              'id': siswa['id'],
              'name': siswa['nama'],
              'nomor_absen': siswa['nomor_absen'],
              'kelas': siswa['kelas'] ?? kelas['nama_kelas'],
              'status': siswa['keterangan'],
              'time': siswa['jam_absen'],
              'catatan': siswa['catatan'] ?? '-',
              'tanggal_absen': siswa['tanggal_absen'] ?? '-',
              'color': _getStatusColor(siswa['keterangan']),
            };
          }).toList();

          // Apply the default filter status
          filterData(selectedFilter.value);
        } else {
          Get.snackbar(
            'Error',
            'Data kelas tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
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

  // Filter the data based on selected status
  void filterData(String filter) {
    selectedFilter.value = filter; // Update selected filter
    if (filter == 'All') {
      filteredSiswaAbsen.value = List.from(siswaAbsen);
    } else {
      filteredSiswaAbsen.value =
          siswaAbsen.where((siswa) => siswa['status'] == filter).toList();
    }
    update(); // Refresh view if necessary
  }

  // Filter data siswa berdasarkan nama (pencarian)
  void searchStudents(String query) {
    // Jika query kosong, kembalikan data sesuai filter status terakhir
    if (query.isEmpty) {
      filterData(selectedFilter.value);
      return;
    }

    filteredSiswaAbsen.assignAll(
      siswaAbsen.where((siswa) {
        final name = siswa['name']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList(),
    );

    update(); // Opsional, jika diperlukan untuk refresh view
  }

  // Get color based on status
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
