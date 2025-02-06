import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'downloadrekappage.dart'; // Pastikan file downloadpdf.dart sudah ada dan terupdate
import 'downloadexcelpage.dart'; // Pastikan file downloadexcel.dart sudah ada

class RekapGuruPage extends StatefulWidget {
  @override
  _RekapGuruPageState createState() => _RekapGuruPageState();
}

class _RekapGuruPageState extends State<RekapGuruPage> {
  List<dynamic> kelasData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRekapData();
  }

  /// Mengambil data rekap absen dari API.
  Future<void> fetchRekapData() async {
    final String url = "https://absen.randijourney.my.id/api/v1/kelas";
    try {
      print("Fetching rekap data from $url...");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          kelasData = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load rekap data");
      }
    } catch (e) {
      print("Error fetching rekap data: $e");
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Gagal mengambil data rekap absen',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Rekap Absen',
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : kelasData.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada data rekap absen.",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: kelasData.length,
                    itemBuilder: (context, index) {
                      final item = kelasData[index];
                      final className =
                          item["nama_kelas"] ?? "Kelas tidak tersedia";
                      final waliKelas =
                          item["nama_user"] ?? "Wali tidak tersedia";

                      // Field 'siswa' biasanya disimpan sebagai string JSON, jadi perlu didecode.
                      final String rawSiswa = item["siswa"] ?? "[]";
                      List<Map<String, dynamic>> siswaData = [];
                      try {
                        final decoded = json.decode(rawSiswa);
                        if (decoded is List) {
                          siswaData = List<Map<String, dynamic>>.from(decoded);
                        }
                      } catch (e) {
                        print("Error decoding siswa data: $e");
                      }
                      return _buildRekapCard(className, waliKelas, siswaData);
                    },
                  ),
      ),
    );
  }

  /// Membuat kartu rekap absen untuk masing-masing kelas
  Widget _buildRekapCard(
      String kelas, String waliKelas, List<Map<String, dynamic>> siswaData) {
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
            _buildButton('Rekap Semester 1', kelas, waliKelas, siswaData),
            SizedBox(height: 10),
            _buildButton('Rekap Semester 2', kelas, waliKelas, siswaData),
          ],
        ),
      ),
    );
  }

  /// Membuat tombol download untuk masing-masing semester.
  /// Saat tombol ditekan, akan memanggil dialog pemilihan format download (PDF/Excel).
  Widget _buildButton(String title, String kelas, String waliKelas,
      List<Map<String, dynamic>> siswaData) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Ekstrak semester dari judul, misalnya "Rekap Semester 1" menghasilkan "1"
              final parts = title.split(' ');
              String sem = parts.length > 1 ? parts.last : "";
              _showFormatDialog(sem, kelas, waliKelas, siswaData);
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

  /// Menampilkan dialog untuk memilih format file download (PDF/Excel).
  void _showFormatDialog(String semester, String kelas, String waliKelas,
      List<Map<String, dynamic>> siswaData) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pilih Format Pengunduhan',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Pilih format file untuk rekap absen semester $semester.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Tutup dialog
                      // Navigasi ke halaman DownloadPDFPage dengan parameter lengkap
                      Get.to(() => DownloadRekapPage(
                            semester: semester,
                            className: kelas,
                            waliKelas: waliKelas,
                            rekapData: siswaData,
                          ));
                    },
                    child: Text(
                      'PDF',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back(); // Tutup dialog
                      // Navigasi ke halaman DownloadExcelPage dengan parameter lengkap
                      Get.to(() => downloadexcelguru(
                            semester: semester,
                            className: kelas,
                            waliKelas: waliKelas,
                            rekapData: siswaData,
                          ));
                    },
                    child: Text(
                      'Excel',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
