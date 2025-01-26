import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class FormAbsenController extends GetxController {
  final idController = TextEditingController(); // Controller untuk ID
  final nameController = TextEditingController();
  final noAbsenController = TextEditingController();
  final kelasController = TextEditingController();
  final catatanController = TextEditingController();
  final jamAbsenController = TextEditingController();
  final tanggalAbsenController = TextEditingController();
  var selectedKeterangan = 'Hadir'.obs; // Default value
  final Dio dio = Dio();

  final List<String> keteranganOptions = [
    'Hadir',
    'Izin',
    'Sakit',
    'Tidak Hadir',
  ];

  @override
  void onInit() {
    super.onInit();
    // Generate random ID siswa
    idController.text = Random().nextInt(100000).toString();

    // Set waktu absen dan tanggal absen ke waktu sekarang
    final now = DateTime.now();
    jamAbsenController.text =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    tanggalAbsenController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> submitAbsen(int classId) async {
    // Validasi input
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        noAbsenController.text.isEmpty ||
        kelasController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Data siswa yang akan ditambahkan
    final siswaData = {
      "id": int.tryParse(idController.text) ??
          DateTime.now().millisecondsSinceEpoch, // ID siswa
      "nama": nameController.text,
      "nomor_absen": noAbsenController.text,
      "kelas": kelasController.text,
      "keterangan": selectedKeterangan.value,
      "jam_absen": jamAbsenController.text,
      "catatan": catatanController.text.isEmpty
          ? "Tidak ada catatan"
          : catatanController.text,
      "tanggal_absen": tanggalAbsenController.text,
    };

    // URL endpoint API
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/update/$classId';

    try {
      print("Mengirim data siswa ke server...");

      // Lakukan PUT request dengan JSON encoded data
      final response = await dio.put(
        url,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
        data: jsonEncode({
          "siswa": [siswaData], // Kirim siswa sebagai array
        }),
      );

      if (response.statusCode == 200) {
        print("Response dari server (PUT): ${response.data}");
        Get.snackbar(
          'Sukses',
          'Absen berhasil disimpan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearFields();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal menyimpan absen.');
      }
    } on DioException catch (dioError) {
      // Mapping error dari Dio
      print("DioError: ${dioError.message}");
      if (dioError.type == DioExceptionType.connectionTimeout) {
        Get.snackbar(
          'Error',
          'Koneksi ke server timeout.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        Get.snackbar(
          'Error',
          'Timeout saat menerima data dari server.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else if (dioError.type == DioExceptionType.badResponse) {
        final errorMessage = dioError.response?.data['message'] ??
            'Kesalahan dari server: ${dioError.response?.statusCode}';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan jaringan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Tangani error lainnya
      print("Unhandled Exception: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // Membersihkan field input
  void clearFields() {
    nameController.clear();
    noAbsenController.clear();
    kelasController.clear();
    catatanController.clear();
    selectedKeterangan.value = 'Hadir';

    // Generate ulang ID, waktu, dan tanggal saat membersihkan
    idController.text = Random().nextInt(100000).toString();
    final now = DateTime.now();
    jamAbsenController.text =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    tanggalAbsenController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
