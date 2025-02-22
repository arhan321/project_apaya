import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';

class EditAkunGuruController extends GetxController {
  final dio.Dio dioClient = dio.Dio();

  /// Data dari Get.arguments (Map) dengan minimal butuh ID user
  final Map<String, dynamic> akun = Get.arguments;

  File? selectedImage;
  final picker = ImagePicker();

  /// Controller field (TextEditingController)
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  /// Variabel untuk menampung tanggal lahir (DateTime).
  DateTime? selectedTanggalLahir;

  /// Field tambahan
  late TextEditingController nipGuruController;
  late TextEditingController waliKelasController;
  late TextEditingController umurController;
  late TextEditingController nomorTelfonController;

  @override
  void onInit() {
    super.onInit();
    print('EditAkunGuruController initialized');
    print('Initial argument data: $akun');

    // Inisialisasi text controller dengan data yang diterima dari Get.arguments
    namaController = TextEditingController(text: akun['nama'] ?? '');
    emailController = TextEditingController(text: akun['email'] ?? '');
    passwordController = TextEditingController(text: akun['password'] ?? '');

    nipGuruController = TextEditingController(text: akun['nip_guru'] ?? '');
    waliKelasController = TextEditingController(text: akun['wali_kelas'] ?? '');
    umurController = TextEditingController(text: akun['umur'] ?? '');
    nomorTelfonController =
        TextEditingController(text: akun['nomor_telfon'] ?? '');

    // Parsing tanggal lahir dari arguments, jika ada
    if (akun['tanggal_lahir'] != null) {
      selectedTanggalLahir = DateTime.tryParse(akun['tanggal_lahir']);
    }
  }

  /// Pilih gambar dari gallery
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    } else {
      print('No image selected.');
    }
  }

  /// PUT / update profile (ke server)
  Future<void> updateProfile() async {
    // Parsing ID agar aman
    final dynamic rawId = akun['id'];
    if (rawId == null) {
      print('ID user tidak ditemukan di arguments!');
      return;
    }
    final int userId = (rawId is int) ? rawId : int.parse(rawId.toString());

    // URL update
    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId';
    print('Updating profile with URL: $url');

    // Validasi sederhana
    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      print('Validation failed: Nama or Email is empty');
      Get.snackbar(
        'Error',
        'Nama dan Email tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Pastikan key sesuai dengan kebutuhan server
      Map<String, dynamic> data = {
        'name': namaController.text,
        'email': emailController.text,
      };

      // Kirim password jika diisi
      if (passwordController.text.isNotEmpty) {
        data['password'] = passwordController.text;
      }

      // Jika user sudah pilih tanggal lahir
      if (selectedTanggalLahir != null) {
        data['tanggal_lahir'] =
            '${selectedTanggalLahir!.year.toString().padLeft(2, '0')}'
            '-${selectedTanggalLahir!.month.toString().padLeft(2, '0')}'
            '-${selectedTanggalLahir!.day.toString().padLeft(2, '0')}';
      }

      // Field tambahan
      data['nip_guru'] = nipGuruController.text;
      data['wali_kelas'] = waliKelasController.text;
      data['umur'] = umurController.text;
      data['nomor_telfon'] = nomorTelfonController.text;

      print('Data to be sent (PUT): $data');

      final response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            // 'Authorization': 'Bearer <YOUR_ACCESS_TOKEN>' // jika butuh token
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Profile updated successfully');
        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back(); // Kembali ke halaman sebelumnya
      } else {
        print('Failed to update profile: ${response.statusCode}');
        print('Response data: ${response.data}');
        Get.snackbar(
          'Error',
          'Gagal memperbarui profil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat memperbarui profil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// POST / upload foto
  Future<void> uploadPhoto() async {
    final dynamic rawId = akun['id'];
    if (rawId == null) {
      print('ID user tidak ditemukan!');
      return;
    }
    final int userId = (rawId is int) ? rawId : int.parse(rawId.toString());

    if (selectedImage == null) {
      print('No image selected for upload');
      Get.snackbar(
        'Error',
        'Pilih foto terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId/foto';
    print('Uploading photo to URL: $url');

    try {
      String fileName = selectedImage!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        'photo': await dio.MultipartFile.fromFile(
          selectedImage!.path,
          filename: fileName,
        ),
      });

      final response = await dioClient.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Photo uploaded successfully');
        Get.snackbar(
          'Berhasil',
          'Foto berhasil diunggah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('Failed to upload photo: ${response.statusCode}');
        print('Response data: ${response.data}');
        Get.snackbar(
          'Error',
          'Gagal mengunggah foto',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error uploading photo: $e');
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mengunggah foto',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Pilih tanggal lahir (DatePicker)
  void selectTanggalLahir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedTanggalLahir) {
      selectedTanggalLahir = picked;
      update(); // Refresh UI
    }
  }
}
