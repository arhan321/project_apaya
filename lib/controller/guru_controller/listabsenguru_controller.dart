import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ListAbsenGuruController extends GetxController {
  var siswaAbsen = <Map<String, dynamic>>[].obs; // Data siswa asli
  var filteredSiswaAbsen =
      <Map<String, dynamic>>[].obs; // Data siswa setelah filter/pencarian
  var isLoading = true.obs; // Indikator loading
  var namaKelas = 'Kelas'.obs; // Nama kelas
  var waliKelas = 'Wali Kelas'.obs; // Nama wali kelas
  int? selectedClassId; // ID kelas yang dipilih
  var searchQuery = ''.obs; // Query pencarian

  @override
  void onInit() {
    super.onInit();
    print("ListAbsenGuruController initialized");
  }

  /// Atur ID kelas secara dinamis dan ambil data
  void setClassId(int classId) {
    if (selectedClassId != classId) {
      print("Setting new classId: $classId");
      selectedClassId = classId;
      fetchData();
    }
  }

  /// Ambil data absensi berdasarkan ID kelas
  Future<void> fetchData() async {
    if (selectedClassId == null) {
      print("fetchData aborted: selectedClassId is null");
      return;
    }

    try {
      isLoading.value = true; // Tampilkan indikator loading
      final response = await http.get(
        Uri.parse('https://absen.randijourney.my.id/api/v1/kelas'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final kelasData = responseData['data'] as List<dynamic>;

        // Cari data kelas berdasarkan selectedClassId
        final kelas = kelasData.firstWhere(
          (k) => k['id'] == selectedClassId,
          orElse: () => null,
        );

        if (kelas != null) {
          final siswaRawJson = kelas['siswa'] as String?;
          if (siswaRawJson != null && siswaRawJson.isNotEmpty) {
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
            // Set filtered data awal sama dengan data asli
            filteredSiswaAbsen.value = siswaAbsen.value;
          } else {
            siswaAbsen.value = [];
            filteredSiswaAbsen.value = [];
          }

          namaKelas.value = kelas['nama_kelas'] ?? 'Kelas';
          waliKelas.value = kelas['nama_user'] ?? 'Wali Kelas';
        } else {
          siswaAbsen.value = [];
          filteredSiswaAbsen.value = [];
        }
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data. Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        siswaAbsen.value = [];
        filteredSiswaAbsen.value = [];
      }
    } catch (e) {
      print("Error fetching data: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengambil data.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      siswaAbsen.value = [];
      filteredSiswaAbsen.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Fungsi untuk menyaring data berdasarkan status (filter)
  void filterData(String status) {
    if (status.isEmpty || status == 'Semua') {
      // Jika tidak ada filter, tampilkan semua data
      filteredSiswaAbsen.value = siswaAbsen.value;
    } else {
      // Filter data berdasarkan status tertentu
      filteredSiswaAbsen.value = siswaAbsen.where((siswa) {
        final siswaStatus = siswa['status']?.toString().toLowerCase() ?? '';
        return siswaStatus == status.toLowerCase();
      }).toList();
    }
  }

  /// Fungsi untuk pencarian siswa berdasarkan nama
  void searchData(String query) {
    searchQuery.value = query; // Simpan query pencarian
    if (query.isEmpty) {
      // Jika query kosong, tampilkan semua data
      filteredSiswaAbsen.value = siswaAbsen.value;
    } else {
      // Filter data berdasarkan nama siswa yang mengandung query
      filteredSiswaAbsen.value = siswaAbsen.where((siswa) {
        final name = siswa['name']?.toString().toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    }
  }

  /// Tentukan warna status
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

  /// Lihat detail absensi siswa
  void viewDetail(Map<String, dynamic> siswa) {
    Get.toNamed('/viewDetail', arguments: siswa);
  }

  /// Edit absensi siswa
  void editAbsen(Map<String, dynamic> siswa) {
    Get.toNamed('/editAbsen', arguments: siswa);
  }

  /// Tambahkan catatan untuk siswa
  void addCatatan(Map<String, dynamic> siswa) {
    Get.toNamed('/catatanGuru', arguments: siswa);
  }
}
