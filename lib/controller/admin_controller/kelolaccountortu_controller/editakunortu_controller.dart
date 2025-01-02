import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';

class EditAkunOrtuController extends GetxController {
  final dio.Dio dioClient = dio.Dio();
  final Map<String, dynamic> akun = Get.arguments;

  File? selectedImage;
  final picker = ImagePicker();

  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void onInit() {
    super.onInit();
    print('EditAkunOrtuController initialized');
    namaController = TextEditingController(text: akun['nama']);
    usernameController = TextEditingController(text: akun['username']);
    emailController = TextEditingController(text: akun['email']);
    passwordController = TextEditingController(text: akun['password']);
    print('Initial data: $akun');
  }

  Future<void> pickImage() async {
    print('Attempting to pick an image...');
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      print('Image selected: ${selectedImage!.path}');
      update();
    } else {
      print('No image selected.');
    }
  }

  Future<void> updateProfile() async {
    final String url =
        'https://absen.djncloud.my.id/api/v1/account/${akun['id']}';
    print('Updating parent account with URL: $url');

    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      print('Validation failed: Nama or Email is empty');
      Get.snackbar('Error', 'Nama dan Email tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      Map<String, dynamic> data = {
        'name': namaController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      };
      print('Data to be sent: $data');

      final response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Parent account updated successfully');
        Get.snackbar('Berhasil', 'Akun orang tua berhasil diperbarui',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        Get.back();
      } else {
        print('Failed to update parent account: ${response.statusCode}');
        Get.snackbar('Error', 'Gagal memperbarui akun orang tua',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error updating parent account: $e');
      Get.snackbar(
          'Kesalahan', 'Terjadi kesalahan saat memperbarui akun orang tua',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> uploadPhoto() async {
    if (selectedImage == null) {
      print('No image selected for upload');
      Get.snackbar('Error', 'Pilih foto terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final String url =
        'https://absen.djncloud.my.id/api/v1/account/${akun['id']}/foto';
    print('Uploading photo to URL: $url');

    try {
      String fileName = selectedImage!.path.split('/').last;
      print('File name: $fileName');

      dio.FormData formData = dio.FormData.fromMap({
        'photo': await dio.MultipartFile.fromFile(selectedImage!.path,
            filename: fileName),
      });

      final response = await dioClient.post(
        url,
        data: formData,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Photo uploaded successfully');
        Get.snackbar('Berhasil', 'Foto berhasil diunggah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        print('Failed to upload photo: ${response.statusCode}');
        Get.snackbar('Error', 'Gagal mengunggah foto',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error uploading photo: $e');
      Get.snackbar('Kesalahan', 'Terjadi kesalahan saat mengunggah foto',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
