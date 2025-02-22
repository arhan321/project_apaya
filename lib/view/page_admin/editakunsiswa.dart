import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/admin_controller/kelolaccountsiswa_controller/editakunsiswa_controller.dart';
import 'dart:io';

class EditAkunSiswa extends StatelessWidget {
  final controller = Get.put(EditAkunSiswaController());

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
          'Edit Akun Siswa',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<EditAkunSiswaController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Foto profil
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: controller.selectedImage != null
                            ? FileImage(controller.selectedImage!)
                            : (controller.akun['foto'] != null
                                    ? NetworkImage(controller.akun['foto'])
                                    : AssetImage('assets/placeholder.png'))
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 20,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Nama
                  TextField(
                    controller: controller.namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // No. Absen
                  TextField(
                    controller: controller.noAbsenController,
                    decoration: InputDecoration(
                      labelText: 'No. Absen',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // NISN
                  TextField(
                    controller: controller.nisnController,
                    decoration: InputDecoration(
                      labelText: 'NISN',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nomor Telepon
                  TextField(
                    controller: controller.nomorTelfonController,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Umur
                  TextField(
                    controller: controller.umurController,
                    decoration: InputDecoration(
                      labelText: 'Umur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Email
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Password
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Tombol Simpan
                  GestureDetector(
                    onTap: controller.updateProfile,
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
                  SizedBox(height: 16),
                  // Tombol Upload Foto
                  GestureDetector(
                    onTap: controller.uploadPhoto,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.lightGreenAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Upload Foto',
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
          );
        },
      ),
    );
  }
}
