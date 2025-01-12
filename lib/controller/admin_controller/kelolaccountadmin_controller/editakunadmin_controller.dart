import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';

class EditAkunAdminController extends GetxController {
  final dio.Dio dioClient = dio.Dio();
  final Map<String, dynamic> akun = Get.arguments;

  File? selectedImage;
  final picker = ImagePicker();

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  DateTime? selectedTanggalLahir;

  @override
  void onInit() {
    super.onInit();
    print('EditAkunAdminController initialized');
    namaController = TextEditingController(text: akun['name']);
    emailController = TextEditingController(text: akun['email']);
    passwordController = TextEditingController(text: akun['password']);
    if (akun['tanggal_lahir'] != null) {
      selectedTanggalLahir = DateTime.tryParse(akun['tanggal_lahir']);
    }
    print('Initial data: $akun');
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    }
  }

  Future<void> updateProfile() async {
    final String url =
        'https://absen.randijourney.my.id/api/v1/account/${akun['id']}';

    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar('Error', 'Nama dan Email tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      Map<String, dynamic> data = {
        'name': namaController.text,
        'email': emailController.text,
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,
        if (selectedTanggalLahir != null)
          'tanggal_lahir':
              '${selectedTanggalLahir!.year}-${selectedTanggalLahir!.month.toString().padLeft(2, '0')}-${selectedTanggalLahir!.day.toString().padLeft(2, '0')}',
      };

      final response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Profil berhasil diperbarui',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.back();
      } else {
        Get.snackbar('Error', 'Gagal memperbarui profil',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Kesalahan', 'Terjadi kesalahan saat memperbarui profil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> uploadPhoto() async {
    if (selectedImage == null) {
      Get.snackbar('Error', 'Pilih foto terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/${akun['id']}/foto';

    try {
      String fileName = selectedImage!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        'photo': await dio.MultipartFile.fromFile(selectedImage!.path,
            filename: fileName),
      });

      final response = await dioClient.post(
        url,
        data: formData,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Foto berhasil diunggah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Gagal mengunggah foto',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Kesalahan', 'Terjadi kesalahan saat mengunggah foto',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void selectTanggalLahir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedTanggalLahir) {
      selectedTanggalLahir = picked;
      update();
    }
  }
}
