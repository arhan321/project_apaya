import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadRekapPage extends StatelessWidget {
  final String className;
  final String waliKelas;
  final String semester; // Semester 1 or 2
  final String schoolName = "SDN Rancagong 1"; // Nama Sekolah

  const DownloadRekapPage({
    Key? key,
    required this.className,
    required this.waliKelas,
    required this.semester,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Rekap Absen',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildRekapItem(
                    name: 'Randi Praditiya',
                    hadir: 20,
                    tidakHadir: 2,
                    izin: 1,
                    sakit: 1,
                  ),
                  _buildRekapItem(
                    name: 'Putra Dewantara',
                    hadir: 22,
                    tidakHadir: 0,
                    izin: 1,
                    sakit: 0,
                  ),
                  _buildRekapItem(
                    name: 'Adi Santoso',
                    hadir: 18,
                    tidakHadir: 3,
                    izin: 2,
                    sakit: 1,
                  ),
                  _buildRekapItem(
                    name: 'Wahyu Kurniawan',
                    hadir: 25,
                    tidakHadir: 0,
                    izin: 0,
                    sakit: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header bagian atas, menampilkan informasi kelas, wali kelas, dan semester
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Rekap Absen $schoolName\n$className - $semester\nWali Kelas: $waliKelas',
        textAlign: TextAlign.left,  // Mengubah alignment header menjadi kiri
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Garis bawah untuk pemisah header
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: Colors.grey[300],
        thickness: 2,
      ),
    );
  }

  // Card untuk menampilkan setiap data siswa dengan latar belakang
  Widget _buildRekapItem({
    required String name,
    required int hadir,
    required int tidakHadir,
    required int izin,
    required int sakit,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildStatusBadge('Hadir: $hadir', Colors.green),
                _buildStatusBadge('Tidak Hadir: $tidakHadir', Colors.red),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildStatusBadge('Izin: $izin', Colors.orange),
                _buildStatusBadge('Sakit: $sakit', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan badge dengan status hadir/tidak hadir/izin/sakit
  Widget _buildStatusBadge(String label, Color badgeColor) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
