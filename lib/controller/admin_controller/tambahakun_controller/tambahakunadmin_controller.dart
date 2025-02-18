import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

class TambahAkunAdminController extends GetxController {
  final dio.Dio _dio = dio.Dio();

  /// ImagePicker instance
  final picker = ImagePicker();

  /// Rx variables untuk menyimpan data input
  var selectedImage = Rxn<File>(); // foto
  var selectedTanggalLahir = Rxn<DateTime>(); // tanggal lahir
  var selectedRole = 'admin'.obs; // Default role = 'admin'

  /// TextEditingController untuk input text
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Fungsi memilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  /// Fungsi memilih tanggal lahir
  /// Perhatikan bahwa kita perlu konteks (BuildContext) untuk menampilkan showDatePicker
  Future<void> selectTanggalLahir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedTanggalLahir.value = picked;
    }
  }

  /// Fungsi untuk mendaftar akun admin
  Future<void> registerAccount(BuildContext context) async {
    const String url =
        'https://absen.randijourney.my.id/api/v1/account/register';

    // Validasi input
    if (namaController.text.isEmpty ||
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
        'role': selectedRole.value,
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
          'Akun berhasil didaftarkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Menampilkan dialog sukses
        Get.dialog(
          AlertDialog(
            title: Text('Berhasil', style: GoogleFonts.poppins(fontSize: 18)),
            content: Text(
              'Akun berhasil dibuat!',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // menutup dialog
                  Get.back(result: true); // kembali ke halaman sebelumnya
                },
                child: Text('OK', style: GoogleFonts.poppins(fontSize: 16)),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal mendaftarkan akun',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on dio.DioError catch (dioError) {
      Get.snackbar(
        'Kesalahan',
        'DioError: ${dioError.response?.data}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan tidak terduga: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
