import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KelolaAbsensiPage extends StatelessWidget {
  // Data kelas dan wali kelas
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
          'Kelola Absensi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              double aspectRatio = constraints.maxWidth > 600 ? 3 / 2 : 4 / 3;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: aspectRatio,
                ),
                itemCount: kelasData.length,
                itemBuilder: (context, index) {
                  final kelas = kelasData[index];
                  return _buildKelasCard(
                    namaKelas: kelas['namaKelas']!,
                    waliKelas: kelas['waliKelas']!,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget Card untuk setiap kelas
  Widget _buildKelasCard({
    required String namaKelas,
    required String waliKelas,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed('/listAbsenAdmin', arguments: {
          'namaKelas': namaKelas,
          'waliKelas': waliKelas,
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.checklist,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
