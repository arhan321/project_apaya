import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CekCatatanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mendapatkan data nama dari argument
    final String name = Get.arguments['name'] ?? 'Tidak Ada Nama';

    // Contoh data catatan harian
    final List<Map<String, String>> catatanHarian = [
      {
        'waktu': '2024-12-10 09:30',
        'isi': 'Ilham menyelesaikan tugas matematika dengan baik.',
      },
      {
        'waktu': '2024-12-12 13:45',
        'isi': 'Ilham terlambat datang ke sekolah.',
      },
    ];

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
          onPressed: () {
            Get.back(); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Catatan Harian',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.blueAccent, // Latar belakang biru
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catatan Harian untuk: $name',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: catatanHarian.length,
                  itemBuilder: (context, index) {
                    final catatan = catatanHarian[index];
                    return Card(
                      color: Colors.white, // Warna kartu tetap putih
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Waktu: ${catatan['waktu']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Teks hitam untuk waktu
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              catatan['isi'] ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black, // Teks hitam untuk isi catatan
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
