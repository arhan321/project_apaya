import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailAbsenOrtu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Terima data dari ListAbsenOrtu
    final Map<String, String> arguments = Get.arguments ?? {};

    final String name = arguments['name'] ?? 'Tidak Ada Nama';
    final String number = arguments['number'] ?? 'Tidak Ada Nomor';
    final String kelas = arguments['kelas'] ?? 'Tidak Ada Kelas';
    final String keterangan = arguments['keterangan'] ?? 'Tidak Ada Keterangan';
    final String jamAbsen = arguments['jamAbsen'] ?? 'Tidak Ada Jam Absen';

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
        title: Text(
          'Detail Absen',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),  // Mengubah warna ikon back menjadi putih
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nama', name),
                SizedBox(height: 8),
                _buildDetailRow('Nomor Absen', number),
                SizedBox(height: 8),
                _buildDetailRow('Kelas', kelas),
                SizedBox(height: 8),
                _buildDetailRow('Keterangan', keterangan),
                SizedBox(height: 8),
                _buildDetailRow('Jam Absen', jamAbsen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
