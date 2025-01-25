import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class TambahKelasPage extends StatefulWidget {
  @override
  _TambahKelasPageState createState() => _TambahKelasPageState();
}

class _TambahKelasPageState extends State<TambahKelasPage> {
  final TextEditingController namaKelasController = TextEditingController();
  final dio.Dio dioClient = dio.Dio();

  bool isUserLoading = true;
  int? selectedUserId;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      debugPrint("Fetching users from $url...");
      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          users = data.where((user) => user['role'] == 'guru').map((user) {
            return {
              'id': int.tryParse(user['id'].toString()) ?? 0,
              'name': user['name'] ?? 'Nama tidak tersedia',
            };
          }).toList();

          if (users.isNotEmpty) {
            selectedUserId = users.first['id'];
          }
          isUserLoading = false;
        });
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil daftar user. Status Code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error fetching users: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mengambil daftar user.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> tambahKelas() async {
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/data-kelas';

    if (namaKelasController.text.isEmpty || selectedUserId == null) {
      Get.snackbar(
        'Error',
        'Nama kelas dan wali kelas tidak boleh kosong.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Map<String, dynamic> data = {
        'nama_kelas': namaKelasController.text,
        'user_id': selectedUserId,
      };

      debugPrint("Mengirim POST ke $url dengan data: $data");

      final response = await dioClient.post(
        url,
        data: jsonEncode(data),
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Kelas berhasil ditambahkan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Kembalikan result ke halaman sebelumnya
        Get.back(result: true);
      } else {
        debugPrint("Gagal menambahkan kelas: ${response.data}");
        Get.snackbar(
          'Error',
          'Gagal menambahkan kelas. Coba lagi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error saat menambahkan kelas: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menambahkan kelas.',
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
          'Tambah Kelas',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: namaKelasController,
              label: "Nama Kelas",
              icon: Icons.class_,
            ),
            SizedBox(height: 20),
            isUserLoading
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Pilih Guru',
                      prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: selectedUserId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedUserId = newValue;
                      });
                    },
                    items: users.map<DropdownMenuItem<int>>((user) {
                      return DropdownMenuItem<int>(
                        value: user['id'],
                        child: Text(user['name'], style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                  ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: tambahKelas,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: GoogleFonts.poppins(),
    );
  }
}
