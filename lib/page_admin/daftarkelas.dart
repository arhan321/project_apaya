import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class DaftarKelasPage extends StatelessWidget {
  final List<Map<String, String>> kelasData = [
    {"namaKelas": "Kelas 6A", "waliKelas": "Bu Siti"},
    {"namaKelas": "Kelas 6B", "waliKelas": "Pak Budi"},
    {"namaKelas": "Kelas 6C", "waliKelas": "Bu Yanti"},
    {"namaKelas": "Kelas 6D", "waliKelas": "Pak Ahmad"},
    {"namaKelas": "Kelas 6E", "waliKelas": "Bu Rina"},
    {"namaKelas": "Kelas 6F", "waliKelas": "Pak Joko"},
  ];

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
          'Daftar Kelas ',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: kelasData.length,
              itemBuilder: (context, index) {
                final kelas = kelasData[index];
                return _buildKelasCard(
                  namaKelas: kelas['namaKelas']!,
                  waliKelas: kelas['waliKelas']!,
                );
              },
            ),
          ),
          // Tombol Tambah Kelas
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.toNamed('/tambahKelas');
              },
              backgroundColor: Colors.blueAccent,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Tambah Kelas',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Card untuk menampilkan daftar kelas dengan tombol Edit
  Widget _buildKelasCard({
    required String namaKelas,
    required String waliKelas,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Informasi kelas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaKelas,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Wali Kelas: $waliKelas",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    "SDN Rancagong 1",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Ikon Edit
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Get.toNamed(
                  '/editKelas',
                  arguments: {
                    'namaKelas': namaKelas,
                    'waliKelas': waliKelas,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
