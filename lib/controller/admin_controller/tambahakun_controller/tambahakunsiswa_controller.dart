import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TambahAkunSiswaController extends GetxController {
  final dio.Dio _dio = dio.Dio();

  /// ImagePicker untuk memilih foto
  final picker = ImagePicker();

  /// Field controller untuk input data
  final namaController = TextEditingController();
  final noAbsenController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Role default = 'siswa'
  var selectedRole = 'siswa';

  /// Tanggal lahir (reaktif)
  var selectedTanggalLahir = Rxn<DateTime>();

  /// Foto yang dipilih (reaktif)
  var selectedImage = Rxn<File>();

  /// Fungsi mengambil gambar
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  /// Fungsi pilih tanggal lahir
  Future<void> selectTanggalLahir(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedTanggalLahir.value = picked;
    }
  }

  /// Fungsi untuk register/mendaftar akun siswa
  Future<void> registerSiswa(BuildContext context) async {
    const String url =
        'https://absen.randijourney.my.id/api/v1/account/register';

    if (namaController.text.isEmpty ||
        noAbsenController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedTanggalLahir.value == null) {
      Get.snackbar(
        'Error',
        'Harap lengkapi semua field',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password dan konfirmasi password tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final formData = dio.FormData.fromMap({
        'name': namaController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'role': selectedRole,
        'nomor_absen': noAbsenController.text,
        'tanggal_lahir':
            DateFormat('yyyy-MM-dd').format(selectedTanggalLahir.value!),
        'photo': selectedImage.value != null
            ? await dio.MultipartFile.fromFile(
                selectedImage.value!.path,
                filename: selectedImage.value!.path.split('/').last,
              )
            : null,
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Akun siswa berhasil didaftarkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Tampilkan dialog sukses
        Get.dialog(
          AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Akun siswa berhasil dibuat!'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.back(); // Kembali ke halaman sebelumnya
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal mendaftarkan akun siswa',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mendaftarkan akun',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
