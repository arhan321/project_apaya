import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../model/admin_model/tambahakun_model/tambahakunguru_model.dart';

class TambahAkunGuruController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();

  /// Text Controllers untuk input data
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Role default = 'guru'
  var selectedRole = 'guru';

  /// Foto yang dipilih (reaktif)
  var selectedImage = Rxn<File>();

  /// Tanggal lahir (reaktif)
  var selectedTanggalLahir = Rxn<DateTime>();

  /// Memilih gambar dari galeri
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  /// Memilih tanggal lahir
  /// Perhatikan: butuh context untuk menampilkan showDatePicker
  Future<void> selectTanggalLahir(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      selectedTanggalLahir.value = pickedDate;
    }
  }

  /// Mendaftarkan akun guru
  Future<void> registerGuru(BuildContext context) async {
    const String url =
        'https://absen.randijourney.my.id/api/v1/account/register';

    // Validasi field
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

    // Validasi password dan konfirmasi
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
        'tanggal_lahir': DateFormat('yyyy-MM-dd').format(
          selectedTanggalLahir.value!,
        ),
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

      // Jika berhasil
      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Akun guru berhasil didaftarkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Tampilkan dialog sukses
        Get.dialog(
          AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Akun guru berhasil dibuat!'),
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
          'Gagal mendaftarkan akun guru',
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
