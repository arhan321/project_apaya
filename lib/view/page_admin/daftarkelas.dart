import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/admin_controller/kelolakelasadmin_controller/daftarkelas_controller.dart'; // Import Controller
// Jika file controller beda folder, sesuaikan path import.

class DaftarKelasPage extends StatelessWidget {
  DaftarKelasPage({Key? key}) : super(key: key);

  /// Kita daftarkan Controller ke GetX.
  /// - 'put()' akan membuat instance Controller jika belum ada.
  final DaftarKelasController controller = Get.put(DaftarKelasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Kelas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// Latar belakang gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Obx(() {
              /// Gunakan Obx agar builder dipanggil ulang saat data berubah
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.kelasData.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada data kelas.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                );
              }

              // Jika ada data, tampilkan ListView
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.kelasData.length,
                itemBuilder: (context, index) {
                  final kelas = controller.kelasData[index];
                  return _buildKelasCard(
                    id: kelas['id'],
                    namaKelas: kelas['nama_kelas'] ?? "Tidak Ada Nama",
                    userId: kelas['user_id'],
                    namaUser: kelas['nama_user'] ?? "Tidak Ada Wali",
                  );
                },
              );
            }),
          ),

          /// Tombol Tambah Kelas
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Get.toNamed('/tambahKelas');
                if (result == true) {
                  /// Memanggil fetchData() ulang jika berhasil tambah
                  controller.fetchData();
                }
              },
              backgroundColor: Colors.blueAccent,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Tambah Kelas',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Card untuk menampilkan daftar kelas
  Widget _buildKelasCard({
    required int id,
    required String namaKelas,
    required int userId,
    required String namaUser,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            /// Info kelas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaKelas,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Wali Kelas: $namaUser",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    "SDN Rancagong 1",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ID Kelas: $id",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// Tombol Edit
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Get.toNamed(
                  '/editKelas',
                  arguments: {
                    'id': id,
                    'nama_kelas': namaKelas,
                    'user_id': userId,
                  },
                )?.then((value) {
                  if (value == true) {
                    controller.fetchData(); // Refresh data jika kelas diubah
                  }
                });
              },
            ),

            /// Tombol Hapus
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: Get.context!,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Hapus Kelas',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Apakah Anda yakin ingin menghapus kelas "$namaKelas"?',
                      style: GoogleFonts.poppins(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(color: Colors.blueAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          controller.deleteKelas(id);
                        },
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
