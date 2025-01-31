import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/siswa_controller/listabsensiswacontroller.dart';

class ListAbsenPage extends StatelessWidget {
  final int classId;
  ListAbsenPage({Key? key, required this.classId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller dengan classId
    final controller = Get.put(ListAbsenController(classId: classId));

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Obx(
          () => Text(
            'Absen ${controller.className.value}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          );
        }

        // Jika tidak ada error dan tidak loading, tampilkan isi
        return Column(
          children: [
            _buildHeader(controller),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = controller.filteredStudents[index];
                    return _buildAbsenCard(
                      controller: controller,
                      name: student['nama'] ?? 'Tidak diketahui',
                      number: 'No ${student['nomor_absen'] ?? '-'}',
                      badge: student['keterangan'] ?? 'Tidak diketahui',
                      jamAbsen: student['jam_absen'] ?? '-',
                      tanggalAbsen: student['tanggal_absen'] ?? '-',
                    );
                  },
                ),
              ),
            ),
            _buildAbsenButton(controller.classId, controller),
          ],
        );
      }),
    );
  }

  // Bagian header yang memuat nama kelas, tanggal, dan search bar + icon filter
  Widget _buildHeader(ListAbsenController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Kelas:',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Obx(
            () => Text(
              controller.className.value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Text(
          // "2025-09-12", // Contoh tanggal statis
          // style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          // ),
          const SizedBox(height: 10),

          // Row untuk search + ikon filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.filterStudents(value),
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cari Nama Siswa',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Ikon filter
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  // Tampilkan bottom sheet filter
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Filter Absensi',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            leading: const Icon(Icons.select_all),
                            title: Text('Semua', style: GoogleFonts.poppins()),
                            onTap: () {
                              controller.applyFilter('Semua');
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: Text('Hadir', style: GoogleFonts.poppins()),
                            onTap: () {
                              controller.applyFilter('Hadir');
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.error_outline),
                            title: Text('Izin', style: GoogleFonts.poppins()),
                            onTap: () {
                              controller.applyFilter('Izin');
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.local_hospital),
                            title: Text('Sakit', style: GoogleFonts.poppins()),
                            onTap: () {
                              controller.applyFilter('Sakit');
                              Get.back();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.cancel_outlined),
                            title: Text('Tidak Hadir',
                                style: GoogleFonts.poppins()),
                            onTap: () {
                              controller.applyFilter('Tidak Hadir');
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Kartu Absensi
  Widget _buildAbsenCard({
    required ListAbsenController controller,
    required String name,
    required String number,
    required String badge,
    required String jamAbsen,
    required String tanggalAbsen,
  }) {
    Color badgeColor;
    switch (badge) {
      case 'Hadir':
        badgeColor = Colors.green;
        break;
      case 'Izin':
        badgeColor = Colors.orange;
        break;
      case 'Sakit':
        badgeColor = Colors.blue;
        break;
      case 'Tidak Hadir':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris: Nama + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kolom nama + nomor
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tanggal: $tanggalAbsen',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jam: $jamAbsen',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              // Badge status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: badgeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Tombol Lihat Detail
          ElevatedButton(
            onPressed: () => Get.toNamed(
              '/viewDetail',
              arguments: {
                'name': name,
                'number': number,
                'kelas': controller.className.value,
                'keterangan': badge,
                'jamAbsen': jamAbsen,
                'tanggalAbsen': tanggalAbsen,
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Warna konsisten
            ),
            child: Text(
              'Lihat Detail',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Tombol “Silahkan Absen”
  Widget _buildAbsenButton(int classId, ListAbsenController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          // Panggil halaman form absen, menunggu result
          final result = await Get.toNamed('/formAbsen', arguments: {
            'classId': classId,
          });
          // Jika form absen memanggil Get.back(result: true), maka result = true
          if (result == true) {
            // Gunakan fetchClassData() karena itu nama metodenya di controller
            controller.fetchClassData();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Silahkan Absen',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
