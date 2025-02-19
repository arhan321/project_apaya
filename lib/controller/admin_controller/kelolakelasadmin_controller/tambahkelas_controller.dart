import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class TambahKelasController extends GetxController {
  /// Controller untuk input nama kelas
  final namaKelasController = TextEditingController();

  /// Dio client
  final dioClient = dio.Dio();

  /// Status loading untuk dropdown
  var isUserLoading = true.obs;

  /// Guru yang dipilih (userId)
  var selectedUserId = Rxn<int>();

  /// Daftar user guru
  var users = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fungsi mengambil data user (role 'guru') dari API
  Future<void> fetchUsers() async {
    const String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Filter user berdasarkan role 'guru'
        final guruList =
            data.where((user) => user['role'] == 'guru').map((user) {
          return {
            'id': int.tryParse(user['id'].toString()) ?? 0,
            'name': user['name'] ?? 'Nama tidak tersedia',
          };
        }).toList();

        users.assignAll(guruList);

        // Set nilai awal selectedUserId jika data user tidak kosong
        if (users.isNotEmpty) {
          selectedUserId.value = users.first['id'];
        }
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil daftar user. Status Code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mengambil daftar user.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Selesai load data user
      isUserLoading.value = false;
    }
  }

  /// Fungsi menambahkan kelas
  Future<void> tambahKelas() async {
    const String url =
        'https://absen.randijourney.my.id/api/v1/kelas/data-kelas';

    // Validasi form
    if (namaKelasController.text.isEmpty || selectedUserId.value == null) {
      Get.snackbar(
        'Error',
        'Nama kelas dan wali kelas tidak boleh kosong.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Map<String, dynamic> data = {
        'nama_kelas': namaKelasController.text,
        'user_id': selectedUserId.value,
      };

      final response = await dioClient.post(
        url,
        data: jsonEncode(data),
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Kelas berhasil ditambahkan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Kembalikan result ke halaman sebelumnya
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          'Gagal menambahkan kelas. Coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menambahkan kelas.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
