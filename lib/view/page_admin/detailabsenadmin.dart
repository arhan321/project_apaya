import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailAbsenAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    final arguments = Get.arguments ?? {};
    final String name = arguments['name'] ?? 'Nama Siswa';
    final String number = arguments['number'] ?? '-';
    final String kelas = arguments['kelas'] ?? '-';
    final String keterangan = arguments['keterangan'] ?? '-';
    final String jamAbsen = arguments['jamAbsen'] ?? '-';
    final String catatan =
        arguments['catatan'] ?? 'Tidak ada catatan'; // Field catatan
    final String tanggalAbsen =
        arguments['tanggal_absen'] ?? '-'; // Field tanggal_absen

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Detail Absen',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Tambahkan scroll jika teks panjang
          child: Card(
            margin: EdgeInsets.all(16),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Nama', name),
                  _buildRow('Nomor Absen', number),
                  _buildRow('Kelas', kelas),
                  _buildRow('Status', keterangan),
                  _buildRow('Jam Absen', jamAbsen),
                  _buildRow('Tanggal Absen',
                      tanggalAbsen), // Menambahkan tanggal absen
                  _buildMultiLineRow(
                      'Catatan', catatan), // Tampilan catatan diperbaiki
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan catatan dengan teks multiline
  Widget _buildMultiLineRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.left, // Teks rata kiri
          ),
        ],
      ),
    );
  }
}
