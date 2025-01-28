import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ListAbsenGuruController extends GetxController {
  var siswaAbsen = <Map<String, dynamic>>[].obs; // Data siswa
  var isLoading = true.obs; // Indikator loading
  var namaKelas = 'Kelas'.obs; // Nama kelas
  var waliKelas = 'Wali Kelas'.obs; // Nama wali kelas
  int? selectedClassId; // ID kelas yang dipilih

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
          } else {
            siswaAbsen.value = [];
          }

          namaKelas.value = kelas['nama_kelas'] ?? 'Kelas';
          waliKelas.value = kelas['nama_user'] ?? 'Wali Kelas';
        } else {
          siswaAbsen.value = [];
        }
      } else {
        siswaAbsen.value = [];
      }
    } catch (e) {
      print("Error fetching data: $e");
      siswaAbsen.value = [];
    } finally {
      isLoading.value = false;
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
}
