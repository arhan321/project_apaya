import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:io';
import 'package:intl/intl.dart';

class TambahAkunOrtu extends StatefulWidget {
  @override
  _TambahAkunOrtuState createState() => _TambahAkunOrtuState();
}

class _TambahAkunOrtuState extends State<TambahAkunOrtu> {
  final dio.Dio _dio = dio.Dio();
  File? _selectedImage;
  final picker = ImagePicker();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime? selectedTanggalLahir;
  String selectedRole = 'orang_tua'; // Default role

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectTanggalLahir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedTanggalLahir) {
      setState(() {
        selectedTanggalLahir = picked;
      });
    }
  }

  Future<void> _registerOrtu() async {
    const String url = 'https://absen.djncloud.my.id/api/v1/account/register';

    if (namaController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        selectedTanggalLahir == null) {
      Get.snackbar('Error', 'Harap lengkapi semua field',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Password dan konfirmasi password tidak cocok',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'name': namaController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'role': selectedRole,
        'tanggal_lahir': DateFormat('yyyy-MM-dd').format(selectedTanggalLahir!),
        'photo': _selectedImage != null
            ? await dio.MultipartFile.fromFile(_selectedImage!.path,
                filename: _selectedImage!.path.split('/').last)
            : null,
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Berhasil', 'Akun orang tua berhasil didaftarkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
        Get.snackbar('Error', 'Gagal mendaftarkan akun orang tua',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Kesalahan', 'Terjadi kesalahan saat mendaftarkan akun',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Tambah Akun Orang Tua',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage('assets/placeholder.png') as ImageProvider,
                    child: _selectedImage == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[300],
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // GestureDetector(
              //   onTap: _selectTanggalLahir,
              //   child: AbsorbPointer(
              //     child: TextField(
              //       decoration: InputDecoration(
              //         labelText: selectedTanggalLahir == null
              //             ? 'Tanggal Lahir'
              //             : DateFormat('yyyy-MM-dd')
              //                 .format(selectedTanggalLahir!),
              //         border: OutlineInputBorder(),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 24),
              GestureDetector(
                onTap: _registerOrtu,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Simpan',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
