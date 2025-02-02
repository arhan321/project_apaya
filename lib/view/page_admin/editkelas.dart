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
  late Map<String, dynamic> kelasData;

  late TextEditingController namaKelasController;
  late int selectedUserId;

  bool isLoading = true;
  bool isUserLoading = true;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();

    namaKelasController = TextEditingController();
    selectedUserId = 0;

    validateAndInitialize();
    fetchUsers();
  }

  void validateAndInitialize() {
    try {
      if (Get.arguments == null || !(Get.arguments is Map<String, dynamic>)) {
        print("Error: Arguments tidak valid atau null");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Error',
            'Data kelas tidak valid atau tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Get.back();
        });
        return;
      }

      kelasData = Get.arguments as Map<String, dynamic>;

      if (kelasData['id'] == null) {
        print("Error: ID kelas tidak ditemukan dalam arguments.");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Error',
            'ID kelas tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Get.back();
        });
        return;
      }

      namaKelasController.text = kelasData['nama_kelas'] ?? '';
      selectedUserId = kelasData['user_id'] != null
          ? int.tryParse(kelasData['user_id'].toString()) ?? 0
          : 0;

      print("Arguments diterima di EditKelasPage: $kelasData");
    } catch (e) {
      print("Unhandled Exception in validateAndInitialize: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUsers() async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      print("Fetching users from $url...");
      final response = await dioClient.get(url);

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          users = data.where((user) => user['role'] == 'guru').map((user) {
            return {
              'id': int.tryParse(user['id'].toString()) ?? 0,
              'name': user['name'] ?? 'Nama tidak tersedia',
            };
          }).toList();

          // Validasi selectedUserId
          if (!users.any((user) => user['id'] == selectedUserId)) {
            selectedUserId = users.isNotEmpty ? users.first['id'] : 0;
          }

          isUserLoading = false;
        });
      } else {
        print("Error fetching users: ${response.data}");
        Get.snackbar(
          'Error',
          'Gagal mengambil daftar user',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error fetching users: $e");
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat mengambil daftar user',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    namaKelasController.dispose();
    super.dispose();
  }

  Future<void> updateKelas() async {
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/${kelasData['id']}';

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

    if (selectedUserId == 0) {
      Get.snackbar(
        'Error',
        'User ID tidak boleh kosong',
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
        'user_id': selectedUserId,
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
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Kelas', style: GoogleFonts.poppins()),
          centerTitle: true,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField('Nama Kelas', namaKelasController),
            const SizedBox(height: 20),
            isUserLoading
                ? CircularProgressIndicator()
                : users.isEmpty
                    ? Text(
                        "Tidak ada guru tersedia",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.red),
                      )
                    : DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Pilih Guru',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon:
                              Icon(Icons.person, color: Colors.blueAccent),
                        ),
                        isExpanded: true,
                        value: selectedUserId,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedUserId = newValue;
                            });
                          }
                        },
                        items: users.map<DropdownMenuItem<int>>((user) {
                          return DropdownMenuItem<int>(
                            value: user['id'],
                            child: Text(user['name'] ?? 'Nama tidak tersedia',
                                style: GoogleFonts.poppins()),
                          );
                        }).toList(),
                      ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: updateKelas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
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
