import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../model/guru_model/tambahabsenguru_model.dart';

class TambahAbsenController extends GetxController {
  // Dio untuk request HTTP
  final Dio dio = Dio();

  // Loading indicator
  RxBool isLoading = false.obs;

  // TextEditingController untuk field
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noAbsenController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();
  final TextEditingController jamAbsenController = TextEditingController();
  final TextEditingController tanggalAbsenController = TextEditingController();

  // Dropdown Keterangan
  final List<String> keteranganOptions = [
    'Hadir',
    'Izin',
    'Sakit',
    'Tidak Hadir',
  ];
  RxString selectedKeterangan = 'Hadir'.obs;

  // Dropdown Kelas (didapat dari API)
  RxList<String> kelasOptions = <String>[].obs;
  RxString selectedKelas = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Generate random ID
    idController.text = Random().nextInt(100000).toString();

    // Set jam & tanggal saat ini
    final now = DateTime.now();
    jamAbsenController.text =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    tanggalAbsenController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Fetch list kelas dari API
    fetchClasses();
  }

  // Ambil data kelas dari endpoint GET /api/v1/kelas
  Future<void> fetchClasses() async {
    try {
      isLoading.value = true;

      final String url = 'https://absen.randijourney.my.id/api/v1/kelas';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<String> kelasList =
            data.map((item) => item['nama_kelas'] as String).toList();

        // Masukkan ke kelasOptions
        kelasOptions.assignAll(kelasList);

        // Pilihan default jika tidak kosong
        if (kelasOptions.isNotEmpty) {
          selectedKelas.value = kelasOptions[0];
        }
      } else {
        throw Exception("Gagal mengambil data kelas dari server.");
      }
    } catch (e) {
      print("Error fetchClasses: $e");
      Get.snackbar(
        'Error',
        'Gagal mengambil data kelas.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAbsen(int classId) async {
    // Validasi form
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        noAbsenController.text.isEmpty ||
        selectedKelas.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field (kecuali catatan) harus diisi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Data absensi yang akan dikirim
    final siswaData = {
      "id": int.tryParse(idController.text) ??
          DateTime.now().millisecondsSinceEpoch,
      "nama": nameController.text,
      "nomor_absen": noAbsenController.text,
      "kelas": selectedKelas.value,
      "keterangan": selectedKeterangan.value,
      "jam_absen": jamAbsenController.text,
      "catatan": catatanController.text.isEmpty
          ? "Tidak ada catatan"
          : catatanController.text,
      "tanggal_absen": tanggalAbsenController.text,
    };

    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/update/$classId';
    print("submitAbsen -> URL: $url");

    try {
      isLoading.value = true;

      final response = await dio.put(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
        data: jsonEncode({
          "siswa": [siswaData],
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        // Bersihkan form
        clearFields();

        // Tampilkan modal dialog untuk konfirmasi sukses
        Get.defaultDialog(
          title: "Sukses",
          middleText: "Absen berhasil disimpan!",
          textConfirm: "OK",
          barrierDismissible: false,
          onConfirm: () {
            Get.back(); // Menutup dialog
            Get.back(result: true); // Kembali ke halaman ListAbsenSiswaPage
          },
        );
      } else {
        throw Exception(response.data['message'] ?? 'Gagal menyimpan absen.');
      }
    } catch (e) {
      print("Error submitAbsen: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Membersihkan field input
  void clearFields() {
    nameController.clear();
    noAbsenController.clear();
    catatanController.clear();
    selectedKeterangan.value = 'Hadir';

    // Generate ulang ID, jam, dan tanggal
    idController.text = Random().nextInt(100000).toString();
    final now = DateTime.now();
    jamAbsenController.text =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    tanggalAbsenController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}
