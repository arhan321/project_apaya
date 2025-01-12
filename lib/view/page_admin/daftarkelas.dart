import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DaftarKelasPage extends StatefulWidget {
  @override
  _DaftarKelasPageState createState() => _DaftarKelasPageState();
}

class _DaftarKelasPageState extends State<DaftarKelasPage> {
  List<dynamic> kelasData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Fetch data from API
  Future<void> fetchData() async {
    final url = Uri.parse("https://absen.randijourney.my.id/api/v1/kelas");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Assign fetched data to kelasData
        setState(() {
          kelasData = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  Future<void> deleteKelas(int id) async {
    final url = Uri.parse("https://absen.randijourney.my.id/api/v1/kelas/$id");

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar(
          'Berhasil',
          'Kelas berhasil dihapus!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchData(); // Refresh daftar kelas setelah penghapusan
      } else {
        throw Exception("Gagal menghapus kelas");
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus kelas',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error: $e");
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
          'Daftar Kelas',
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
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Loading spinner
                : ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: kelasData.length,
                    itemBuilder: (context, index) {
                      final kelas = kelasData[index];
                      return _buildKelasCard(
                        id: kelas['id'], // Kirimkan ID ke halaman Edit
                        namaKelas: kelas['nama_kelas'] ?? "Tidak Ada Nama",
                        userId: kelas[
                            'user_id'], // Kirimkan user_id ke halaman Edit
                        namaUser: kelas['nama_user'] ?? "Tidak Ada Wali",
                      );
                    },
                  ),
          ),
          // Tombol Tambah Kelas
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Get.toNamed(
                    '/tambahKelas'); // Navigasi ke TambahKelasPage
                if (result == true) {
                  fetchData(); // Refresh daftar kelas jika berhasil
                }
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

  // Widget Card untuk menampilkan daftar kelas dengan tombol Edit dan Delete
  Widget _buildKelasCard({
    required int id,
    required String namaKelas,
    required int userId,
    required String namaUser,
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
                    "Wali Kelas: $namaUser",
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
                    'id': id, // Kirim ID
                    'nama_kelas': namaKelas,
                    'user_id': userId,
                  },
                )?.then((value) {
                  if (value == true) {
                    fetchData(); // Refresh daftar kelas jika berhasil diubah
                  }
                });
              },
            ),
            // Ikon Delete
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Hapus Kelas',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'Apakah Anda yakin ingin menghapus kelas "$namaKelas"?',
                      style: GoogleFonts.poppins(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(color: Colors.blueAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          deleteKelas(id);
                        },
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
