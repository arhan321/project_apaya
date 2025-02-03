import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/admin_controller/listabsenadmin_controller/listabsenadmin_controller.dart';

class ListAbsenAdminPage extends StatelessWidget {
  final ListAbsenAdminController controller =
      Get.put(ListAbsenAdminController());

  @override
  Widget build(BuildContext context) {
    // Call fetchData initially when the page is loaded
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.siswaAbsen.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada data absensi untuk kelas ini.',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(controller.waliKelas),
                ListView.builder(
                  padding: EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.siswaAbsen.length,
                  itemBuilder: (context, index) {
                    final siswa = controller.siswaAbsen[index];
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
                      siswa['tanggal_absen'] ?? '-', // Tambahkan tanggal_absen
                    );
                  },
                ),
              ],
            ),
          );
        }
      }),
    );
  }

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
              Icon(Icons.filter_list, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenCard(
    String name,
    String number,
    String status,
    Color statusColor,
    String jamAbsen,
    String kelas,
    int siswaId,
    String keterangan,
    String catatan, // Parameter untuk dikirim ke detail
    String tanggalAbsen, // Tanggal absen
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
              // Kolom informasi siswa
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
                  // Baris untuk menampilkan tanggal absen
                  Text(
                    'Tanggal: $tanggalAbsen',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  // Baris untuk menampilkan jam absen
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
          // Baris tombol aksi
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
                      'keterangan': keterangan, // Kirim keterangan ke detail
                      'catatan': catatan, // Kirim catatan ke detail
                      'tanggal_absen':
                          tanggalAbsen, // Kirim tanggal_absen ke detail
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
                      'kelasId': controller.selectedClassId, // ID kelas
                      'siswaId': siswaId, // ID siswa
                      'name': name,
                      'number': number,
                      'status': status,
                      'jamAbsen': jamAbsen,
                      'tanggalAbsen': tanggalAbsen, // Tambahkan tanggal_absen
                      'catatan': catatan, // Kirim catatan ke halaman edit
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
                  // Refresh data setelah catatan berhasil dikirim
                  controller.fetchData();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Beri Catatan',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
