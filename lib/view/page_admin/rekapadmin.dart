import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RekapAdminPage extends StatelessWidget {
  final Dio _dio = Dio(); // Inisialisasi Dio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          'Rekap Absenn',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildRekapCard(context, 'Kelas 6A', 'Tatang Sutarman'),
            _buildRekapCard(context, 'Kelas 5B', 'Siti Fatimah'),
            _buildRekapCard(context, 'Kelas 4C', 'Ahmad Fauzan'),
          ],
        ),
      ),
    );
  }

  Widget _buildRekapCard(BuildContext context, String kelas, String waliKelas) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(bottom: 16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kelas,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Wali Kelas: $waliKelas',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 15),
            _buildButton(context, 'Rekap Semester 1', kelas, waliKelas),
            SizedBox(height: 10),
            _buildButton(context, 'Rekap Semester 2', kelas, waliKelas),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, String kelas, String waliKelas) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showFormatDialog(context, title.split(' ').last, kelas, waliKelas);
            },
            icon: Icon(Icons.download, color: Colors.white),
            label: Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Menampilkan dialog untuk memilih format unduhan (PDF atau Excel)
  void _showFormatDialog(BuildContext context, String semester, String kelas, String waliKelas) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Format Pengunduhan'),
          content: Text('Pilih format file untuk rekap absen $semester.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _downloadPDF(kelas, waliKelas, semester);
              },
              child: Text('PDF', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Tambahkan logika untuk mengunduh file Excel jika diperlukan
                print('Download Excel');
              },
              child: Text('Excel', style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengunduh PDF menggunakan Dio
  void _downloadPDF(String kelas, String waliKelas, String semester) {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text(
              'Rekap Absen $kelas - Semester $semester\nWali Kelas: $waliKelas',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Randi Praditiya: Hadir 20, Tidak Hadir 2, Izin 1, Sakit 1'),
            pw.Text('Putra Dewantara: Hadir 22, Tidak Hadir 0, Izin 1, Sakit 0'),
            pw.Text('Adi Santoso: Hadir 18, Tidak Hadir 3, Izin 2, Sakit 1'),
            pw.Text('Wahyu Kurniawan: Hadir 25, Tidak Hadir 0, Izin 0, Sakit 0'),
          ],
        );
      },
    ),
  );

  // Menyimpan PDF ke file byte array
  pdf.save().then((bytes) {
    // Membuat Blob dengan byte PDF
    final blob = html.Blob([bytes]);

    // Membuat URL untuk file yang ingin diunduh
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Membuat elemen anchor untuk mendownload file
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'  // Memastikan file tidak dibuka di tab baru
      ..download = 'RekapAbsen_${kelas}_$semester.pdf' // Nama file PDF
      ..click(); // Memulai download dengan klik otomatis

    // Hapus URL setelah digunakan
    html.Url.revokeObjectUrl(url);
  });
}

}
