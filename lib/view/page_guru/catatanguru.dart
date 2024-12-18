import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CatatanGuruPage extends StatelessWidget {
  // Controller untuk TextField
  final TextEditingController _catatanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Mengambil data 'name' dari arguments
    final Map<String, dynamic> arguments = Get.arguments;
    final String studentName = arguments['name'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Mengubah warna ikon back menjadi putih
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Beri Catatan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white), // Menggunakan font Poppins dan warna putih
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan nama siswa yang dipilih dengan font Poppins
            Text(
              'Beri Catatan untuk $studentName',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 120, 118, 118)),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _catatanController, // Menambahkan controller
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis catatan di sini...',
                hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Mendapatkan teks dari TextField
                  String catatan = _catatanController.text.trim();

                  // Jika catatan kosong, tampilkan pop-up
                  if (catatan.isEmpty) {
                    // Menampilkan Snackbar jika catatan kosong
                    Get.snackbar(
                      'Catatan Harus Diisi', // Judul Snackbar
                      'Tolong isi catatan sebelum mengirim.', // Pesan Snackbar
                      snackPosition: SnackPosition.BOTTOM, // Posisi snackbar di bawah
                      backgroundColor: Colors.red, // Warna latar belakang
                      colorText: Colors.white, // Warna teks
                      borderRadius: 8, // Sudut border
                      margin: EdgeInsets.all(10), // Margin sekitar snackbar
                      padding: EdgeInsets.all(16), // Padding di dalam snackbar
                    );
                  } else {
                    // Menampilkan Snackbar jika catatan berhasil dikirim
                    Get.snackbar(
                      'Catatan Dikirim', // Judul Snackbar
                      'Catatan untuk $studentName telah dikirim.', // Pesan Snackbar
                      snackPosition: SnackPosition.BOTTOM, // Posisi snackbar di bawah
                      backgroundColor: Colors.green, // Warna latar belakang
                      colorText: Colors.white, // Warna teks
                      borderRadius: 8, // Sudut border
                      margin: EdgeInsets.all(10), // Margin sekitar snackbar
                      padding: EdgeInsets.all(16), // Padding di dalam snackbar
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Warna tombol
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Kirim Catatan',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white), // Menggunakan font Poppins dan teks putih
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
