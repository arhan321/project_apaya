import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class CatatanAdminPage extends StatelessWidget {
  final TextEditingController catatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final String name = arguments['name'] ?? 'Nama Siswa';
    final int kelasId = arguments['kelasId'] ?? 0; // ID kelas
    final int siswaId = arguments['siswaId'] ?? 0; // ID siswa

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Beri Catatan',
          style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beri Catatan untuk $name',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            TextField(
              controller: catatanController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis catatan di sini...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (catatanController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Catatan tidak boleh kosong.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  // Kirim catatan ke server
                  final response = await _sendCatatan(
                    kelasId: kelasId,
                    siswaId: siswaId,
                    catatan: catatanController.text,
                  );

                  if (response['success']) {
                    Get.snackbar(
                      'Berhasil',
                      response['message'] ?? 'Catatan berhasil dikirim.',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );

                    // Tambahkan notifikasi dialog sukses
                    await Get.defaultDialog(
                      title: "Berhasil",
                      titleStyle: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      middleText: "Catatan untuk $name berhasil diperbarui!",
                      middleTextStyle: GoogleFonts.poppins(fontSize: 16),
                      textConfirm: "OK",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.green,
                      onConfirm: () {
                        Get.back(); // Tutup dialog
                        Get.back(result: true); // Kembali ke halaman sebelumnya
                      },
                    );
                  } else {
                    Get.snackbar(
                      'Gagal',
                      response['message'] ?? 'Terjadi kesalahan.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    if (response['error'] != null) {
                      debugPrint('Detail Error: ${response['error']}');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'Kirim Catatan',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _sendCatatan({
    required int kelasId,
    required int siswaId,
    required String catatan,
  }) async {
    final Dio dio = Dio();
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/update/$kelasId';

    try {
      final response = await dio.put(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // Header Content-Type
            'Accept': 'application/json', // Header Accept
          },
        ),
        data: {
          'siswa': [
            {
              'id': siswaId,
              'nama': Get.arguments?['name'] ?? 'Unknown', // Pastikan ada nama
              'catatan': catatan, // Tambahkan catatan ke siswa
            },
          ],
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Catatan berhasil disimpan.',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Gagal menyimpan catatan.',
          'error': response.data,
        };
      }
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint('Error Response Data: ${e.response?.data}');
        debugPrint('Error Response Status: ${e.response?.statusCode}');
        return {
          'success': false,
          'message': 'Gagal menyimpan catatan.',
          'error': e.response?.data,
        };
      } else {
        debugPrint('DioError: ${e.message}');
        return {
          'success': false,
          'message': 'Terjadi kesalahan jaringan.',
          'error': e.message,
        };
      }
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan tidak terduga.',
        'error': e.toString(),
      };
    }
  }
}
