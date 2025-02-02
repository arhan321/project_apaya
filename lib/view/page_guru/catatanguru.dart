import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

// Misalnya untuk auto refresh:
import '../../controller/guru_controller/listabsenguru_controller.dart';

class CatatanGuruPage extends StatelessWidget {
  final TextEditingController _catatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari arguments
    final Map<String, dynamic> arguments = Get.arguments ?? {};
    final String studentName = arguments['name'] ?? 'Nama Siswa';
    final int kelasId = arguments['kelasId'] ?? 0; // ID kelas
    final int siswaId = arguments['siswaId'] ?? 0; // ID siswa

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Beri Catatan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan nama siswa
            Text(
              'Beri Catatan untuk $studentName',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 120, 118, 118),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _catatanController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis catatan di sini...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String catatan = _catatanController.text.trim();

                  // Jika catatan kosong, tampilkan Snackbar
                  if (catatan.isEmpty) {
                    Get.snackbar(
                      'Catatan Harus Diisi',
                      'Tolong isi catatan sebelum mengirim.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      borderRadius: 8,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(16),
                    );
                    return;
                  }

                  // Kirim catatan ke server
                  final response = await _sendCatatan(
                    kelasId: kelasId,
                    siswaId: siswaId,
                    name: studentName, // Pastikan nama siswa dikirim
                    catatan: catatan,
                  );

                  if (response['success']) {
                    // Tampilkan dialog sukses
                    await Get.defaultDialog(
                      title: "Berhasil",
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      middleText:
                          "Catatan untuk $studentName berhasil diperbarui!",
                      middleTextStyle: GoogleFonts.poppins(fontSize: 16),
                      textConfirm: "OK",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.green,
                      onConfirm: () {
                        // 1. Tutup dialog
                        Get.back();

                        // 2. Refresh data di halaman sebelumnya
                        final listAbsenGuruController =
                            Get.find<ListAbsenGuruController>();
                        listAbsenGuruController.fetchData();

                        // 3. Kembali ke halaman list absen
                        Get.back();
                      },
                    );
                  } else {
                    // Jika gagal, tampilkan snackbar
                    Get.snackbar(
                      'Gagal',
                      response['message'] ?? 'Terjadi kesalahan.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    if (response['error'] != null) {
                      debugPrint('Detail Error: ${response['error']}');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Kirim Catatan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mengirim catatan ke server
  Future<Map<String, dynamic>> _sendCatatan({
    required int kelasId,
    required int siswaId,
    required String catatan,
    required String name,
  }) async {
    final Dio dio = Dio();
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/update/$kelasId';

    try {
      debugPrint("Sending catatan to API...");
      debugPrint("URL: $url");
      debugPrint("Payload: ${{
        "siswa": [
          {
            "id": siswaId,
            "nama": name,
            "catatan": catatan,
          }
        ]
      }}");

      final response = await dio.put(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: {
          "siswa": [
            {
              "id": siswaId,
              "nama": name,
              "catatan": catatan,
            }
          ]
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

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
      // Jika error dari sisi Dio (server)
      if (e.response != null) {
        debugPrint('Error Response Data: ${e.response?.data}');
        debugPrint('Error Response Status: ${e.response?.statusCode}');
        return {
          'success': false,
          'message': 'Gagal menyimpan catatan.',
          'error': e.response?.data,
        };
      } else {
        // Error yang bukan dari response server
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
