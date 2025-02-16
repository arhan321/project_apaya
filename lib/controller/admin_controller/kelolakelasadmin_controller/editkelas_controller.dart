import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditKelasController extends GetxController {
  /// Dio client untuk memanggil API
  final Dio dioClient = Dio();

  /// Data kelas (dikirim dari arguments)
  var kelasData = <String, dynamic>{}.obs;

  /// Controller untuk TextField nama kelas
  final TextEditingController namaKelasController = TextEditingController();

  /// ID user (guru) yang dipilih
  var selectedUserId = 0.obs;

  /// Loading state ketika mengambil data dari server
  var isLoading = true.obs;

  /// Loading state ketika mengambil daftar user (guru)
  var isUserLoading = true.obs;

  /// Daftar user (guru)
  var users = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Validasi arguments + set data awal
    validateAndInitialize();
    // Ambil daftar guru
    fetchUsers();
  }

  @override
  void onClose() {
    // Ingat untuk dispose TextEditingController bila perlu
    namaKelasController.dispose();
    super.onClose();
  }

  /// Validasi arguments yang dikirim ke halaman ini, lalu inisialisasi.
  void validateAndInitialize() {
    try {
      final args = Get.arguments;
      if (args == null || args is! Map<String, dynamic>) {
        // Error: arguments tidak valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Error',
            'Data kelas tidak valid atau tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Get.back();
        });
        return;
      }

      kelasData.value = args; // simpan ke obs
      final idKelas = kelasData['id'];
      if (idKelas == null) {
        // Error: ID kelas tidak ada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Error',
            'ID kelas tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Get.back();
        });
        return;
      }

      // isi textfield
      namaKelasController.text = kelasData['nama_kelas'] ?? '';
      // user id
      selectedUserId.value = kelasData['user_id'] != null
          ? int.tryParse("${kelasData['user_id']}") ?? 0
          : 0;

      debugPrint("Arguments diterima di EditKelasPage: $kelasData");
    } catch (e) {
      debugPrint("Unhandled Exception in validateAndInitialize: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Ambil daftar user (guru) dari API
  Future<void> fetchUsers() async {
    const String url = 'https://absen.randijourney.my.id/api/v1/account';
    debugPrint("Fetching users from $url...");
    try {
      final response = await dioClient.get(url);
      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // Filter user role guru
        final guruList =
            data.where((user) => user['role'] == 'guru').map((user) {
          return {
            'id': int.tryParse('${user['id']}') ?? 0,
            'name': user['name'] ?? 'Nama tidak tersedia',
          };
        }).toList();

        users.assignAll(guruList);

        // Validasi selectedUserId, jika tidak ada di list => set default
        if (!users.any((user) => user['id'] == selectedUserId.value)) {
          selectedUserId.value = users.isNotEmpty ? users.first['id'] : 0;
        }
        isUserLoading.value = false;
      } else {
        debugPrint("Error fetching users: ${response.data}");
        Get.snackbar(
          'Error',
          'Gagal mengambil daftar user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mengambil daftar user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Memperbarui data kelas ke server
  Future<void> updateKelas() async {
    final idKelas = kelasData['id'];
    if (idKelas == null) {
      // Jika idKelas tidak valid
      Get.snackbar(
        'Error',
        'ID Kelas tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String url = 'https://absen.randijourney.my.id/api/v1/kelas/$idKelas';

    // Validasi form
    if (namaKelasController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama Kelas tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (selectedUserId.value == 0) {
      Get.snackbar(
        'Error',
        'User ID tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Mulai loading
    isLoading.value = true;

    try {
      Map<String, dynamic> dataBody = {
        'nama_kelas': namaKelasController.text,
        'user_id': selectedUserId.value,
      };

      debugPrint("Mengirim PUT ke $url dengan data: $dataBody");

      final response = await dioClient.put(
        url,
        data: jsonEncode(dataBody),
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        // Sukses
        Get.snackbar(
          'Berhasil',
          'Data kelas berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Balik ke halaman sebelumnya
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          'Gagal memperbarui data kelas: ${response.data}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Unhandled Exception: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
