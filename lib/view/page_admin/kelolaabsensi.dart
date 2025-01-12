import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class KelolaAbsensiPage extends StatefulWidget {
  @override
  _KelolaAbsensiPageState createState() => _KelolaAbsensiPageState();
}

class _KelolaAbsensiPageState extends State<KelolaAbsensiPage> {
  List<dynamic> kelasData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKelasData();
  }

  Future<void> fetchKelasData() async {
    final String url = "https://absen.randijourney.my.id/api/v1/kelas";

    try {
      print("Fetching data from $url...");
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          kelasData = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load kelas data");
      }
    } catch (e) {
      print("Error fetching kelas data: $e");
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Gagal mengambil data kelas',
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    double aspectRatio =
                        constraints.maxWidth > 600 ? 3 / 2 : 4 / 3;

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
                          id: kelas['id'], // Kirim ID kelas
                          namaKelas: kelas['nama_kelas'] ?? 'Tidak Ada Nama',
                          waliKelas: kelas['nama_user'] ?? 'Tidak Ada Wali',
                        );
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildKelasCard({
    required int id,
    required String namaKelas,
    required String waliKelas,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed('/listAbsenAdmin', arguments: {
          'id': id, // Kirim ID kelas ke halaman berikutnya
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
