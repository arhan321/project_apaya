import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditAkunAdminController extends GetxController {
  final dio.Dio dioClient = dio.Dio();

  // Data akun yang dikirim melalui Get.arguments
  final Map<String, dynamic> akun = Get.arguments;

  File? selectedImage;
  final picker = ImagePicker();

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController passwordController; // Akan diisi '********'
  late TextEditingController nomorTelfonController;
  late TextEditingController nipGuruController;
  late TextEditingController umurController;

  DateTime? selectedTanggalLahir;

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
    print('EditAkunAdminController onInit() - Diterima akun: $akun');

    // Isi form dengan data dari akun, kecuali password.
    namaController = TextEditingController(text: akun['username'] ?? '');
    emailController = TextEditingController(text: akun['email'] ?? '');

    // Password selalu tampil "disamarkan"
    // Jika user tidak mengganti, kita tidak kirim password ke server.
    // Jika user mengganti (passwordController != '********'), maka update.
    passwordController = TextEditingController(text: '********');

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
  }

  /// Memilih foto dari gallery
  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      print("pickImage() - Image selected: ${selectedImage!.path}");
      update();
    }
  }

  /// Method untuk update data akun
  Future<void> updateProfile() async {
    print("updateProfile() called");

    // Pastikan userId valid
    final String? userId = akun['id']?.toString();
    if (userId == null) {
      print("updateProfile() - akun['id'] is null. Cannot proceed.");
      Get.snackbar(
        'Error',
        'User ID tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId';

    // Validasi sederhana
    if (namaController.text.isEmpty || emailController.text.isEmpty) {
      print("updateProfile() - Nama / Email kosong");
      Get.snackbar(
        'Error',
        'Nama dan Email tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Hanya kirim password jika user mengetik sesuatu berbeda dari '********'
    String? finalPassword;
    if (passwordController.text != '********') {
      finalPassword =
          passwordController.text; // user benar-benar ganti password
    }

    // Buat data payload
    Map<String, dynamic> data = {
      'username': namaController.text,
      'email': emailController.text,

      // Jika finalPassword != null, berarti user ganti password
      if (finalPassword != null) 'password': finalPassword,

      if (selectedTanggalLahir != null)
        'tanggal_lahir':
            '${selectedTanggalLahir!.year}-${selectedTanggalLahir!.month.toString().padLeft(2, '0')}-${selectedTanggalLahir!.day.toString().padLeft(2, '0')}',
      'nomor_telfon': nomorTelfonController.text,
      'nip_guru': nipGuruController.text,
      'umur': umurController.text,
      'agama': selectedAgama,
    };

    print("updateProfile() - Sending data: $data");

    try {
      final response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      print("updateProfile() - Response status: ${response.statusCode}");
      print("updateProfile() - Response data: ${response.data}");

      if (response.statusCode == 200) {
        // Tampilkan dialog sukses
        Get.defaultDialog(
          title: "Berhasil",
          middleText: "Data akun admin berhasil diperbarui!",
          textConfirm: "OK",
          confirmTextColor: Colors.white,
          onConfirm: () {
            // Tutup dialog
            Get.back();

            // Arahkan ke halaman list akun admin
            // Pastikan route '/listAkunadmin' ada di getPages
            Get.offNamed('/listAkunadmin');
          },
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal memperbarui profil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("updateProfile() - Error detail: $e");

      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat memperbarui profil',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Upload foto
  Future<void> uploadPhoto() async {
    print("uploadPhoto() called");
    if (selectedImage == null) {
      print("uploadPhoto() - No image selected");
      Get.snackbar(
        'Error',
        'Pilih foto terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String? userId = akun['id']?.toString();
    if (userId == null) {
      print("uploadPhoto() - akun['id'] is null. Cannot proceed.");
      Get.snackbar(
        'Error',
        'User ID tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final String url =
        'https://absen.randijourney.my.id/api/v1/account/$userId/foto';

    try {
      String fileName = selectedImage!.path.split('/').last;

      dio.FormData formData = dio.FormData.fromMap({
        'photo': await dio.MultipartFile.fromFile(
          selectedImage!.path,
          filename: fileName,
        ),
      });

      print("uploadPhoto() - Uploading file: $fileName to $url");

      final response = await dioClient.post(
        url,
        data: formData,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      print("uploadPhoto() - Response status: ${response.statusCode}");
      print("uploadPhoto() - Response data: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Foto berhasil diunggah',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengunggah foto',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("uploadPhoto() - Error detail: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mengunggah foto',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Memilih tanggal lahir melalui date picker
  void selectTanggalLahir(BuildContext context) async {
    print("selectTanggalLahir() called");
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedTanggalLahir) {
      selectedTanggalLahir = picked;
      print("selectTanggalLahir() - Picked date: $picked");
      update();
    }
  }
}
