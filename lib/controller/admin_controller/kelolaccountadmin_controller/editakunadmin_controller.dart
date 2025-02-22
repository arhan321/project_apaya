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
  // Tampilkan password lama
  late TextEditingController passwordController;

  // Field tambahan
  late TextEditingController nomorTelfonController;
  late TextEditingController nipGuruController;
  late TextEditingController umurController;

  DateTime? selectedTanggalLahir;

  // Dropdown untuk agama (prefilled dengan data lama)
  String selectedAgama = 'islam';
  final List<String> listAgama = [
    'islam',
    'kristen',
    'katolik',
    'hindu',
    'budha',
    'konghucu'
  ];

  @override
  void onInit() {
    super.onInit();
    print('EditAkunAdminController initialized');
    // Load semua data lama (old data)
    namaController = TextEditingController(text: akun['username'] ?? '');
    emailController = TextEditingController(text: akun['email'] ?? '');
    passwordController = TextEditingController(text: akun['password'] ?? '');
    nomorTelfonController =
        TextEditingController(text: akun['nomor_telfon'] ?? '');
    nipGuruController = TextEditingController(text: akun['nip_guru'] ?? '');
    umurController = TextEditingController(text: akun['umur'] ?? '');
    if (akun['tanggal_lahir'] != null &&
        akun['tanggal_lahir'].toString().isNotEmpty) {
      selectedTanggalLahir = DateTime.tryParse(akun['tanggal_lahir']);
    }
    if (akun['agama'] != null && akun['agama'].toString().isNotEmpty) {
      selectedAgama = akun['agama'].toString();
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
        'username': namaController.text,
        'email': emailController.text,
        // Kirim password lama jika tidak diubah atau jika diisi
        'password': passwordController.text,
        if (selectedTanggalLahir != null)
          'tanggal_lahir':
              '${selectedTanggalLahir!.year}-${selectedTanggalLahir!.month.toString().padLeft(2, '0')}-${selectedTanggalLahir!.day.toString().padLeft(2, '0')}',
        'nomor_telfon': nomorTelfonController.text,
        'nip_guru': nipGuruController.text,
        'umur': umurController.text,
        'agama': selectedAgama,
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
