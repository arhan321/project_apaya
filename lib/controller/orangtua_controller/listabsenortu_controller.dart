import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListAbsenOrtuController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var className = ''.obs;
  var namaUser = ''.obs; // Nama Guru
  var students = <Map<String, dynamic>>[].obs;
  var filteredStudents = <Map<String, dynamic>>[].obs;

  final String baseUrl = 'https://absen.randijourney.my.id/api/v1/';

  void fetchClassData(int classId) async {
    final String classUrl = '${baseUrl}kelas/$classId';
    final String accountUrl = '${baseUrl}account';

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch data kelas
      final response = await GetConnect().get(classUrl);

      if (response.statusCode == 200) {
        final data = response.body['data'];
        print("Response Data Kelas: $data");

        // Ambil user_id untuk mencari nama guru
        int userId = data['user_id'] ?? 0;
        print("User ID Guru: $userId");

        // Ambil nama kelas
        className.value = data['nama_kelas'] ?? 'Tidak diketahui';

        // Parsing data siswa (karena masih berupa string JSON)
        if (data['siswa'] is String) {
          try {
            students.value = (jsonDecode(data['siswa']) as List)
                .map((e) => e as Map<String, dynamic>)
                .toList();
          } catch (e) {
            print("Gagal decode siswa: $e");
            students.value = [];
          }
        } else {
          students.value = (data['siswa'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }

        filteredStudents.value = List.from(students);

        // Jika user_id valid, ambil nama dari API account
        if (userId > 0) {
          await fetchUserName(userId, accountUrl);
        }
      } else {
        errorMessage.value =
            'Gagal memuat data kelas. Status Code: ${response.statusCode}';
        print("Error Fetching Kelas: ${response.body}");
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data kelas.';
      print("Error Fetch Class Data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserName(int userId, String accountUrl) async {
    try {
      final response = await GetConnect().get(accountUrl);

      if (response.statusCode == 200) {
        final dynamic responseData = response.body;

        print("Raw Response from Account API: $responseData");

        // Cek apakah response langsung berupa List (tanpa key 'data')
        if (responseData is List) {
          final List<Map<String, dynamic>> users =
              responseData.cast<Map<String, dynamic>>();

          print("Parsed Users List: $users");

          // Cari user berdasarkan user_id (pastikan tipe ID cocok)
          final Map<String, dynamic>? user = users.firstWhere(
            (u) => int.tryParse(u['id'].toString()) == userId,
            orElse: () => {},
          );

          if (user!.isNotEmpty) {
            print("Nama Guru Ditemukan: ${user['name']}");
            namaUser.value = user['name'] ?? 'Tidak diketahui';
          } else {
            print("Nama Guru tidak ditemukan untuk ID $userId");
            namaUser.value = 'Tidak diketahui';
          }
        } else {
          print(
              "API Response format tidak sesuai! Harusnya List, tetapi mendapat ${responseData.runtimeType}");
        }
      } else {
        print("Error Fetching Account Data: ${response.body}");
      }
    } catch (e) {
      print("Error Fetching User Name: $e");
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
