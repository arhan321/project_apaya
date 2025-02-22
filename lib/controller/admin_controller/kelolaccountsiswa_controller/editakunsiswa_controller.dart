import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';

class EditAkunSiswaController extends GetxController {
  final dio.Dio dioClient = dio.Dio();
  final Map<String, dynamic> akun = Get.arguments;

  File? selectedImage;
  final picker = ImagePicker();

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController noAbsenController;
  // Field tambahan untuk siswa
  late TextEditingController nisnController;
  late TextEditingController nomorTelfonController;
  late TextEditingController umurController;

  DateTime? selectedTanggalLahir;

  @override
  void onInit() {
    super.onInit();
    print('EditAkunSiswaController initialized');
    // Inisialisasi controller dengan data yang diterima melalui Get.arguments
    namaController = TextEditingController(text: akun['nama']);
    emailController = TextEditingController(text: akun['email']);
    passwordController = TextEditingController(text: akun['password']);
    noAbsenController = TextEditingController(text: akun['nomor_absen']);
    nisnController = TextEditingController(text: akun['nisn']);
    nomorTelfonController = TextEditingController(text: akun['nomor_telfon']);
    umurController = TextEditingController(text: akun['umur']);

    if (akun['tanggal_lahir'] != null) {
      selectedTanggalLahir = DateTime.tryParse(akun['tanggal_lahir']);
    }
    print('Initial data: $akun');
  }

  Future<void> pickImage() async {
    print('Attempting to pick an image...');
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      print('Image selected: ${selectedImage!.path}');
      update(); // Refresh the UI
    } else {
      print('No image selected.');
    }
  }

  Future<void> updateProfile() async {
    final String url =
        'https://absen.randijourney.my.id/api/v1/account/${akun['id']}';
    print('Updating student account with URL: $url');

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
        'email': emailController.text,
        if (passwordController.text.isNotEmpty)
          'password': passwordController.text,
        'nomor_absen': noAbsenController.text,
        // Field tambahan untuk siswa
        'nisn': nisnController.text,
        'nomor_telfon': nomorTelfonController.text,
        'umur': umurController.text,
        if (selectedTanggalLahir != null)
          'tanggal_lahir':
              '${selectedTanggalLahir!.year}-${selectedTanggalLahir!.month.toString().padLeft(2, '0')}-${selectedTanggalLahir!.day.toString().padLeft(2, '0')}',
      };
      print('Data to be sent: $data');

      final response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Student account updated successfully');
        // Tampilkan modal dialog untuk konfirmasi sukses
        Get.defaultDialog(
          title: "Sukses",
          middleText: "Data berhasil di edit",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back(); // Menutup dialog
            Get.offNamed(
                '/listAkunSiswa'); // Navigasi ke halaman list akun siswa
          },
        );
      } else {
        print('Failed to update student account: ${response.statusCode}');
        Get.snackbar('Error', 'Gagal memperbarui akun siswa',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error updating student account: $e');
      Get.snackbar('Kesalahan', 'Terjadi kesalahan saat memperbarui akun siswa',
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
        'https://absen.randijourney.my.id/api/v1/account/${akun['id']}/foto';
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

  void selectTanggalLahir(BuildContext context) async {
    print('Opening date picker...');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedTanggalLahir) {
      selectedTanggalLahir = picked;
      print('Selected date: $selectedTanggalLahir');
      update();
    } else {
      print('No date selected.');
    }
  }
}
