import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/admin_controller/kelolaccountadmin_controller/editakunadmin_controller.dart';
import 'dart:io';

class EditProfileAdminPage extends StatelessWidget {
  final controller = Get.put(EditAkunAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Edit Akun Admin',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<EditAkunAdminController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Foto Profil
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
                            radius: 20,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Nama (Prefilled dengan data lama)
                  TextField(
                    controller: controller.namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Email (Tetap prefilled dengan data lama)
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Password (Prefilled dengan data lama)
                  TextField(
                    controller: controller.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Tanggal Lahir (DatePicker, prefill jika data lama ada)
                  GestureDetector(
                    onTap: () => controller.selectTanggalLahir(context),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: controller.selectedTanggalLahir == null
                              ? 'Tanggal Lahir'
                              : '${controller.selectedTanggalLahir!.year}-${controller.selectedTanggalLahir!.month.toString().padLeft(2, '0')}-${controller.selectedTanggalLahir!.day.toString().padLeft(2, '0')}',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nomor Telepon (Prefilled dengan data lama)
                  TextField(
                    controller: controller.nomorTelfonController,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // NIP Guru (Prefilled dengan data lama)
                  TextField(
                    controller: controller.nipGuruController,
                    decoration: InputDecoration(
                      labelText: 'NIP Guru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Umur (Prefilled dengan data lama)
                  TextField(
                    controller: controller.umurController,
                    decoration: InputDecoration(
                      labelText: 'Umur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Dropdown Agama (Prefilled dengan data lama)
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Agama',
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedAgama,
                    items: controller.listAgama
                        .map((agama) => DropdownMenuItem<String>(
                              value: agama,
                              child: Text(agama),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedAgama = value;
                        controller.update();
                      }
                    },
                  ),
                  SizedBox(height: 24),
                  // Tombol Simpan Perubahan
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
                          'Simpan Perubahan',
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
