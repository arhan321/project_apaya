import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};

    // Pastikan data memiliki nilai default jika null
    final String name = args['name'] ?? 'Tidak diketahui';
    final String number = args['number'] ?? '-';
    final String kelas = args['kelas'] ?? 'Tidak diketahui';
    final String keterangan = args['keterangan'] ?? 'Tidak diketahui';
    final String jamAbsen = args['jamAbsen'] ?? '-';
    final String tanggalAbsen = args['tanggalAbsen'] ?? '-';

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
          'Detail Absen',
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
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(label: 'Nama', value: name),
                SizedBox(height: 15),
                _buildDetailRow(label: 'Nomor Absen', value: number),
                SizedBox(height: 15),
                _buildDetailRow(label: 'Kelas', value: kelas),
                SizedBox(height: 15),
                _buildDetailRow(label: 'Keterangan', value: keterangan),
                SizedBox(height: 15),
                _buildDetailRow(label: 'Jam Absen', value: jamAbsen),
                SizedBox(height: 15),
                _buildDetailRow(label: 'Tanggal Absen', value: tanggalAbsen),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
