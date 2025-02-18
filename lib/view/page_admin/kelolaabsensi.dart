import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/admin_controller/kelolaabsenadmin_controller/kelolaabsenadmin_controller.dart';

class KelolaAbsensiPage extends StatelessWidget {
  KelolaAbsensiPage({Key? key}) : super(key: key);

  final KelolaAbsensiController controller = Get.put(KelolaAbsensiController());

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
          'Kelola Absensi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        /// Gunakan Obx agar widget rebuild saat isLoading atau kelasData berubah
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Jika tidak loading, tampilkan data
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsif: atur crossAxisCount dan aspectRatio
                int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                double aspectRatio = constraints.maxWidth > 600 ? 3 / 2 : 4 / 3;

                // Jika data kosong, tampilkan teks
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

                // Tampilkan grid
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: controller.kelasData.length,
                  itemBuilder: (context, index) {
                    final kelas = controller.kelasData[index];
                    return _buildKelasCard(
                      id: kelas.id,
                      namaKelas: kelas.namaKelas,
                      waliKelas: kelas.namaUser,
                    );
                  },
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildKelasCard({
    required int id,
    required String namaKelas,
    required String waliKelas,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed('/listAbsenAdmin', arguments: {
          'id': id, // Kirim ID kelas ke halaman berikutnya
          'namaKelas': namaKelas,
          'waliKelas': waliKelas,
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purpleAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                "Wali Kelas: $waliKelas",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.checklist,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
