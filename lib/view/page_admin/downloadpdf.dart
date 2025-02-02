import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
          'Rekap Absen PDDF',
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
            ElevatedButton(
              onPressed: _downloadPDF,
              child: Text('Download PDF'),
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

  // Fungsi untuk mengunduh PDF
  Future<void> _downloadPDF() async {
    final pdf = pw.Document();

    // Menambahkan konten ke dalam PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Rekap Absen $schoolName\n$className - Semester $semester\nWali Kelas: $waliKelas',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              // Daftar siswa
              pw.Text('Randi Praditiya: Hadir 20, Tidak Hadir 2, Izin 1, Sakit 1'),
              pw.Text('Putra Dewantara: Hadir 22, Tidak Hadir 0, Izin 1, Sakit 0'),
              pw.Text('Adi Santoso: Hadir 18, Tidak Hadir 3, Izin 2, Sakit 1'),
              pw.Text('Wahyu Kurniawan: Hadir 25, Tidak Hadir 0, Izin 0, Sakit 0'),
            ],
          );
        },
      ),
    );

    // Konversi PDF ke file byte array
    final bytes = await pdf.save();

    // Mengunduh PDF menggunakan HTML API
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'RekapAbsen_${className}_$semester.pdf'
      ..click();
    html.Url.revokeObjectUrl(url); // Menghapus URL setelah digunakan
  }
}
