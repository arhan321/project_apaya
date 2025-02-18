import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/admin_controller/kelolaakun_controller/listakunguru_controller.dart';

class ListAkunGuru extends StatelessWidget {
  /// Injeksi controller menggunakan Get.put
  final ListAkunGuruController controller = Get.put(ListAkunGuruController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Daftar Akun Guru',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        /// Obx untuk memantau perubahan isLoading dan errorMessage
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
            ),
          );
        }

        return _buildListAkun();
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /// Navigation ke Tambah Akun Guru (ubah sesuai kebutuhan route)
          Get.toNamed('/tambahAkunGuru');
        },
        label: Text(
          'Tambah Akun',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildListAkun() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Obx(() {
        /// Memantau perubahan pada list akunGuru
        if (controller.akunGuru.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada akun guru tersedia.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.akunGuru.length,
          itemBuilder: (context, index) {
            final akun = controller.akunGuru[index];
            return _buildAkunCard(
              context,
              id: akun['id'],
              foto: akun['foto'] ?? '',
              nama: akun['nama'] ?? '',
              email: akun['email'] ?? '',
              password: akun['password'] ?? '',
              role: akun['role'] ?? '',
            );
          },
        );
      }),
    );
  }

  Widget _buildAkunCard(
    BuildContext context, {
    required String id,
    required String foto,
    required String nama,
    required String email,
    required String password,
    required String role,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: foto.isNotEmpty
                  ? NetworkImage(foto)
                  : const AssetImage('assets/default_profile.png')
                      as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint('Gagal memuat gambar: $exception');
              },
              child: foto.isEmpty
                  ? const Text(
                      'No Image',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      textAlign: TextAlign.center,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Email: $email',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Password: $password',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Role: $role',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                /// Navigation ke Edit Akun Guru (ubah sesuai kebutuhan route)
                Get.toNamed('/editAkunGuru', arguments: {
                  'id': id,
                  'foto': foto,
                  'nama': nama,
                  'email': email,
                  'password': password,
                  'role': role,
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                controller.deleteAkunGuru(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
