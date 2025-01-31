import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/guru_controller/listabsenguru_controller.dart';

class ListAbsenSiswaPage extends StatelessWidget {
  final int classId;

  ListAbsenSiswaPage({required this.classId}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ListAbsenGuruController>();
      controller.setClassId(classId);
    });
  }

  final ListAbsenGuruController controller = Get.put(ListAbsenGuruController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Daftar Absensi ${controller.namaKelas.value}',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.white),
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Obx(() {
            if (controller.isLoading.value) {
              return Expanded(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.siswaAbsen.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Tidak ada data absensi.',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.filteredSiswaAbsen.length,
                itemBuilder: (context, index) {
                  final siswa = controller.filteredSiswaAbsen[index];
                  return _buildAbsenCard(
                    siswa['name'] ?? 'Tidak ada nama',
                    siswa['nomor_absen'] ?? '-',
                    siswa['status'] ?? 'Tidak ada status',
                    siswa['color'] ?? Colors.grey,
                    siswa['time'] ?? 'Tidak ada waktu',
                    siswa['id'], // ID siswa
                    siswa['catatan'] ?? '-',
                    siswa['tanggal_absen'] ?? '-',
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/tambahAbsen');
        },
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Absen Siswa',
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final List<String> daysOfWeek = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final String dayName = daysOfWeek[now.weekday % 7];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang',
            style: GoogleFonts.poppins(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Obx(() => Text(
                controller.waliKelas.value,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              )),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
              Text(
                dayName,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    controller.searchData(
                        value); // Memanggil fungsi pencarian dari controller
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cari Nama Siswa',
                    hintStyle: GoogleFonts.poppins(fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Logika untuk membuka filter modal
                  Get.bottomSheet(
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Filter Siswa',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListTile(
                            title: Text('Hadir', style: GoogleFonts.poppins()),
                            onTap: () {
                              // Filter siswa yang hadir
                              print('Filter: Hadir');
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: Text('Izin', style: GoogleFonts.poppins()),
                            onTap: () {
                              // Filter siswa yang izin
                              print('Filter: Izin');
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: Text('Sakit', style: GoogleFonts.poppins()),
                            onTap: () {
                              // Filter siswa yang sakit
                              print('Filter: Sakit');
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: Text('Semua', style: GoogleFonts.poppins()),
                            onTap: () {
                              // Reset filter
                              print('Filter: Semua');
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.filter_list, color: Colors.white),
                tooltip: 'Filter',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenCard(String name, String number, String status,
      Color statusColor, String time, int id, String catatan, String tanggal) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No Absen $number',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/detailAbsenGuru', arguments: {
                      'name': name,
                      'number': number,
                      'kelas': controller.namaKelas.value,
                      'keterangan': status,
                      'jamAbsen': time,
                      'tanggalAbsen': tanggal,
                      'catatan': catatan,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Lihat Detail',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/editAbsen', arguments: {
                      'kelasId': classId, // Pastikan ini benar
                      'id': id,
                      'guruId': id, // Pastikan ID ini sesuai dengan API
                      'name': name,
                      'number': number,
                      'keterangan': status,
                      'jamAbsen': time,
                      'tanggalAbsen': tanggal,
                      'catatan': catatan,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/catatanGuru', arguments: {
                      'id': id,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Beri Catatan',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
