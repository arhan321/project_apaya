import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAbsenAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final String namaKelas = arguments['namaKelas'] ?? 'Kelas';
    final String waliKelas = arguments['waliKelas'] ?? 'Wali Kelas';

    final List<Map<String, dynamic>> siswaAbsen = [
      {'name': 'Dina Pramudya', 'number': 'No 1', 'status': 'Hadir', 'time': '08:15', 'color': Colors.green},
      {'name': 'Rudi Santoso', 'number': 'No 2', 'status': 'Sakit', 'time': '09:00', 'color': Colors.blue},
      {'name': 'Lisa Anggraini', 'number': 'No 3', 'status': 'Izin', 'time': '10:00', 'color': Colors.orange},
      {'name': 'Budi Kurniawan', 'number': 'No 4', 'status': 'Tidak Hadir', 'time': '-', 'color': Colors.red},
    ];

    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Daftar Absensi $namaKelas',
    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
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
            _buildHeader(waliKelas),
            ListView.builder(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: siswaAbsen.length,
              itemBuilder: (context, index) {
                final siswa = siswaAbsen[index];
                return _buildAbsenCard(
                  siswa['name'],
                  siswa['number'],
                  siswa['status'],
                  siswa['color'],
                  siswa['time'],
                  namaKelas,
                );
              },
            ),
          ],
        ),
      ),
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
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
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
      String name, String number, String status, Color statusColor, String jamAbsen, String kelas) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text(number, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/detailAbsenAdmin', arguments: {
                      'name': name,
                      'number': number,
                      'kelas': kelas,
                      'keterangan': status,
                      'jamAbsen': jamAbsen,
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: Text('Lihat Detail', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/editAbsenAdmin', arguments: {
                      'name': name,
                      'number': number,
                      'status': status,
                      'jamAbsen': jamAbsen,
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                  child: Text('Edit', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/catatanAdmin', arguments: {'name': name});
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Beri Catatan', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
