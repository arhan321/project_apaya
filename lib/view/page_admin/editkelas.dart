import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart' as dio;

class EditKelasPage extends StatefulWidget {
  @override
  _EditKelasPageState createState() => _EditKelasPageState();
}

class _EditKelasPageState extends State<EditKelasPage> {
  final dio.Dio dioClient = dio.Dio();
  final Map<String, dynamic> kelasData = Get.arguments;

  late TextEditingController namaKelasController;
  late TextEditingController userIdController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    namaKelasController =
        TextEditingController(text: kelasData['nama_kelas'] ?? '');
    userIdController =
        TextEditingController(text: kelasData['user_id']?.toString() ?? '');
  }

  @override
  void dispose() {
    namaKelasController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  Future<void> updateKelas() async {
    final String url =
        'https://absen.djncloud.my.id/api/v1/kelas/${kelasData['id']}';

    // Validasi input
    if (namaKelasController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Nama Kelas tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (userIdController.text.isEmpty ||
        int.tryParse(userIdController.text) == null) {
      Get.snackbar(
        'Error',
        'User ID harus berupa angka yang valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> data = {
        'nama_kelas': namaKelasController.text,
        'user_id': int.parse(userIdController.text),
      };

      print("Mengirim PUT ke $url dengan data: $data");

      final response = await dioClient.put(
        url,
        data: jsonEncode(data),
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Data kelas berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Gagal memperbarui data kelas: ${response.data}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Unhandled Exception: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
        title: Text(
          'Edit Kelas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField('Nama Kelas', namaKelasController),
                  const SizedBox(height: 20),
                  _buildInputField('User ID', userIdController),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: updateKelas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
                      ),
                      child: Text(
                        "Simpan Perubahan",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
