import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadPDFPage extends StatelessWidget {
  final String className; // Nama kelas, dikirim dari halaman sebelumnya
  final String waliKelas; // Nama wali kelas, dikirim dari halaman sebelumnya
  final String semester; // Semester, dikirim dari halaman sebelumnya
  final String schoolName = "SDN Rancagong 1"; // Nama sekolah statis

  const DownloadPDFPage({
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
          'Rekap Absen PDF',
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
        color: Colors.white,
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

  // Header bagian atas menampilkan informasi kelas, wali kelas, dan semester
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Rekap Absen $schoolName\n$className - Semester $semester\nWali Kelas: $waliKelas',
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Membuat tampilan rekap siswa
  Widget _buildRekapItem({
    required String name,
    required int hadir,
    required int tidakHadir,
    required int izin,
    required int sakit,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Hadir: $hadir',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              Text('Tidak Hadir: $tidakHadir',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              Text('Izin: $izin',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              Text('Sakit: $sakit',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
