import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListAbsenOrtuController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var className = ''.obs;
  var students = <Map<String, dynamic>>[].obs;
  var filteredStudents = <Map<String, dynamic>>[].obs;

  void fetchClassData(int classId) async {
    const String urlBase = 'https://absen.randijourney.my.id/api/v1/kelas/';
    final String url = '$urlBase$classId';

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await GetConnect().get(url);

      if (response.statusCode == 200) {
        final data = response.body['data'];

        className.value = data['nama_kelas'] ?? 'Tidak diketahui';
        students.value = (jsonDecode(data['siswa']) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        filteredStudents.value = List.from(students);
      } else {
        errorMessage.value =
            'Gagal memuat data. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
    } finally {
      isLoading.value = false;
    }
  }

  void filterStudents(String query) {
    filteredStudents.value = students
        .where((student) =>
            student['nama']?.toLowerCase()?.contains(query.toLowerCase()) ??
            false)
        .toList();
  }

  void applyFilter(String status) {
    if (status == "Semua") {
      filteredStudents.value = List.from(students);
    } else {
      filteredStudents.value =
          students.where((student) => student['keterangan'] == status).toList();
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return Colors.green;
      case 'Sakit':
        return Colors.blue;
      case 'Izin':
        return Colors.orange;
      case 'Tidak Hadir':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
