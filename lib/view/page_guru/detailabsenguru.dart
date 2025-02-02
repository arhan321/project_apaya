import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailAbsenGuruPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    final arguments = Get.arguments ?? {};
    print("Arguments: $arguments");

    final String name = arguments['name'] ?? 'Nama Siswa';
    final String number = arguments['number'] ?? '-';
    final String kelas = arguments['kelas'] ?? '-';
    final String keterangan = arguments['keterangan'] ?? '-';
    final String jamAbsen = arguments['jamAbsen'] ?? '-';
    final String catatan = arguments['catatan'] ?? 'Tidak ada catatan';
    final String tanggal = arguments['tanggalAbsen'] ??
        '-'; // Diperbaiki agar sesuai dengan pengiriman data

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Detail Absen',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                  _buildRow('Tanggal Absen', tanggal),
                  _buildMultiLineRow('Catatan', catatan),
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
        crossAxisAlignment: CrossAxisAlignment
            .start, // Supaya teks panjang tidak naik ke tengah
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.right,
              maxLines: 2, // Tambahan supaya tidak terpotong
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

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
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.left,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
