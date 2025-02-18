import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahAkunOrtuController extends GetxController {
  final dio.Dio _dio = dio.Dio();

  /// Instance ImagePicker
  final picker = ImagePicker();

  /// TextEditingController untuk setiap input
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// Role default = 'orang_tua'
  var selectedRole = 'orang_tua';

  /// File gambar yang dipilih (reaktif)
  var selectedImage = Rxn<File>();

  /// Fungsi memilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  /// Mendaftarkan akun orang tua ke server
  Future<void> registerOrtu() async {
    const String url =
        'https://absen.randijourney.my.id/api/v1/account/register';

    // Validasi input
    if (namaController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Harap lengkapi semua field',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi password
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
        'name': namaController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'role': selectedRole,
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
          'Akun orang tua berhasil didaftarkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Tampilkan dialog sukses
        Get.dialog(
          AlertDialog(
            title: Text('Berhasil', style: GoogleFonts.poppins(fontSize: 18)),
            content: Text('Akun orang tua berhasil dibuat!',
                style: GoogleFonts.poppins(fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.back(); // Kembali ke halaman sebelumnya
                },
                child: Text('OK', style: GoogleFonts.poppins(fontSize: 16)),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal mendaftarkan akun orang tua',
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
