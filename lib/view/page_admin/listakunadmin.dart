import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

import '../../controller/admin_controller/kelolaakun_controller/listakunadmin_controller.dart'; // Pastikan path controller benar

class ListAkunAdminPage extends StatelessWidget {
  ListAkunAdminPage({Key? key}) : super(key: key);

  // Inisialisasi controller via Get.put (atau Get.find jika sudah di-bind)
  final ListAkunAdminController controller = Get.put(ListAkunAdminController());

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
          'Daftar Akun Admin',
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
        // Reaktif: rebuild saat isLoading atau errorMessage berubah
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return _buildErrorWidget(controller.errorMessage.value);
        } else {
          return _buildListAkun();
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/tambahAkunAdmin');
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
        if (controller.akunAdmin.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada akun admin tersedia.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.akunAdmin.length,
          itemBuilder: (context, index) {
            final akun = controller.akunAdmin[index];
            return _buildAkunCard(
              id: akun['id'] ?? '',
              foto: akun['foto'] ?? '',
              username: akun['username'] ?? '',
              email: akun['email'] ?? '',
              password: akun['password'] ?? '',
              role: akun['role'] ?? '',
              nomorTelfon: akun['nomor_telfon'] ?? '',
              agama: akun['agama'] ?? '',
              nipGuru: akun['nip_guru'] ?? '',
              tanggalLahir: akun['tanggal_lahir'] ?? '',
              umur: akun['umur'] ?? '',
            );
          },
        );
      }),
    );
  }

  Widget _buildAkunCard({
    required String id,
    required String foto,
    required String username,
    required String email,
    required String password,
    required String role,
    required String nomorTelfon,
    required String agama,
    required String nipGuru,
    required String tanggalLahir,
    required String umur,
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
            ),
            const SizedBox(width: 16),
            // Tampilan detail akun
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
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
                    'Role: $role',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Password: ********',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nomor Telepon: $nomorTelfon',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Agama: $agama',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'NIP Guru: $nipGuru',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Tanggal Lahir: $tanggalLahir',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Umur: $umur',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            // Tombol Edit & Delete
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    Get.toNamed('/editProfileAdmin', arguments: {
                      'id': id,
                      'foto': foto,
                      'username': username,
                      'email': email,
                      'password': password,
                      'role': role,
                      'nomor_telfon': nomorTelfon,
                      'agama': agama,
                      'nip_guru': nipGuru,
                      'tanggal_lahir': tanggalLahir,
                      'umur': umur,
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Konfirmasi",
                      middleText: "Apakah Anda yakin ingin menghapus akun ini?",
                      textCancel: "Batal",
                      textConfirm: "Hapus",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back();
                        controller.deleteAkun(id);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
      ),
    );
  }
}
