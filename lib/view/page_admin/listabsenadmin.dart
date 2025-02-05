import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/admin_controller/listabsenadmin_controller/listabsenadmin_controller.dart';

class ListAbsenAdminPage extends StatelessWidget {
  final ListAbsenAdminController controller =
      Get.put(ListAbsenAdminController());

  @override
  Widget build(BuildContext context) {
    // Pastikan fetchData dipanggil jika diperlukan
    controller.fetchData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Absensi ${controller.namaKelas}',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(controller.waliKelas),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.filteredSiswaAbsen.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada siswa yang ditemukan.',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.filteredSiswaAbsen.length,
                itemBuilder: (context, index) {
                  final siswa = controller.filteredSiswaAbsen[index];
                  return _buildAbsenCard(
                    siswa['name'] ?? 'Tidak ada nama',
                    siswa['nomor_absen'] ?? '-', // Nomor Absen
                    siswa['status'] ?? 'Tidak ada status',
                    siswa['color'] ?? Colors.grey,
                    siswa['time'] ?? 'Tidak ada waktu',
                    siswa['kelas'] ?? '-', // Kelas
                    siswa['id'], // ID Siswa
                    siswa['status'] ?? 'Tidak ada keterangan', // Keterangan
                    siswa['catatan'] ?? '', // Catatan siswa
                    siswa['tanggal_absen'] ?? '-', // Tanggal Absen
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // Header section with welcome text and search bar
  Widget _buildHeader(String waliKelas) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang',
            style: GoogleFonts.poppins(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            waliKelas,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    controller
                        .searchStudents(value); // Panggil method pencarian
                  },
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cari Nama Siswa',
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
                icon: Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  _showFilterBottomSheet(controller); // Show filter options
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bottom Sheet Filter
  void _showFilterBottomSheet(ListAbsenAdminController controller) {
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
                controller.filterData('All');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text('Hadir', style: GoogleFonts.poppins()),
              onTap: () {
                controller.filterData('Hadir');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text('Izin', style: GoogleFonts.poppins()),
              onTap: () {
                controller.filterData('Izin');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: Text('Sakit', style: GoogleFonts.poppins()),
              onTap: () {
                controller.filterData('Sakit');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: Text('Tidak Hadir', style: GoogleFonts.poppins()),
              onTap: () {
                controller.filterData('Tidak Hadir');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Absen Card for each student
  Widget _buildAbsenCard(
    String name,
    String number,
    String status,
    Color statusColor,
    String jamAbsen,
    String kelas,
    int siswaId,
    String keterangan,
    String catatan,
    String tanggalAbsen,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Informasi siswa
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'No Absen $number',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tanggal: $tanggalAbsen',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jam: $jamAbsen',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              // Tampilan status absensi
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/detailAbsenAdmin', arguments: {
                      'kelasId': controller.selectedClassId,
                      'siswaId': siswaId,
                      'name': name,
                      'number': number,
                      'status': status,
                      'kelas': kelas,
                      'jamAbsen': jamAbsen,
                      'keterangan': keterangan,
                      'catatan': catatan,
                      'tanggal_absen': tanggalAbsen,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  child: Text(
                    'Lihat Detail',
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/editAbsenAdmin', arguments: {
                      'kelasId': controller.selectedClassId,
                      'siswaId': siswaId,
                      'name': name,
                      'number': number,
                      'status': status,
                      'jamAbsen': jamAbsen,
                      'tanggalAbsen': tanggalAbsen,
                      'catatan': catatan,
                    })?.then((value) {
                      controller.fetchData(); // Refresh data setelah edit
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                  ),
                  child: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Tombol Beri Catatan
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Get.toNamed('/catatanAdmin', arguments: {
                  'kelasId': controller.selectedClassId,
                  'siswaId': siswaId,
                  'name': name,
                });
                if (result == true) {
                  controller.fetchData();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(
                'Beri Catatan',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
