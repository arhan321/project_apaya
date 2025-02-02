import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
// Misalkan kita butuh controller:
import '../../controller/guru_controller/listabsenguru_controller.dart';

class EditAbsenPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController jamAbsenController = TextEditingController();
  final TextEditingController tanggalAbsenController = TextEditingController();
  final List<String> statusList = ['Hadir', 'Sakit', 'Izin', 'Tidak Hadir'];

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final int kelasId = arguments['kelasId'] ?? 0;
    final int siswaId = arguments['siswaId'] ?? 0;

    // Isi text controller dengan data lama (jika ada)
    namaController.text = arguments['name'] ?? '';
    nomorController.text = arguments['number'] ?? '';
    jamAbsenController.text = arguments['jamAbsen'] ?? '';
    tanggalAbsenController.text = arguments['tanggalAbsen'] ?? '';

    String selectedStatus = arguments['keterangan'] ?? 'Hadir';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Edit Absen',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
          children: [
            _buildTextField('Nama Siswa', namaController),
            SizedBox(height: 12),
            _buildTextField('Nomor Absen / Nomor Induk', nomorController),
            SizedBox(height: 12),
            _buildDropdown(
              'Status Absensi',
              selectedStatus,
              statusList,
              (value) => selectedStatus = value ?? 'Hadir',
            ),
            SizedBox(height: 12),
            _buildTextField('Jam Absen (HH:MM)', jamAbsenController),
            SizedBox(height: 12),
            _buildTextField(
              'Tanggal Absen (YYYY-MM-DD)',
              tanggalAbsenController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final response = await _updateAbsen(
                  kelasId: kelasId,
                  siswaId: siswaId,
                  nama: namaController.text,
                  nomor: nomorController.text,
                  jamAbsen: jamAbsenController.text,
                  status: selectedStatus,
                  tanggalAbsen: tanggalAbsenController.text,
                );

                if (response['success']) {
                  // Tampilkan dialog
                  Get.defaultDialog(
                    title: 'Berhasil',
                    middleText: response['message'],
                    textConfirm: 'OK',
                    onConfirm: () {
                      // Tutup dialog
                      Get.back();

                      // Lakukan refresh data di halaman sebelumnya
                      // 1) Temukan controller list absensi guru
                      final listAbsenGuruController =
                          Get.find<ListAbsenGuruController>();

                      // 2) Panggil metode fetchData (sesuaikan nama metodenya)
                      listAbsenGuruController.fetchData();

                      // 3) Kembali ke halaman list
                      Get.back();
                    },
                  );
                } else {
                  Get.snackbar(
                    'Gagal',
                    response['message'],
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  debugPrint('Error detail: ${response['error']}');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Simpan Perubahan',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: GoogleFonts.poppins()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<Map<String, dynamic>> _updateAbsen({
    required int kelasId,
    required int siswaId,
    required String nama,
    required String nomor,
    required String jamAbsen,
    required String status,
    required String tanggalAbsen,
  }) async {
    final Dio dio = Dio();
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/update/$kelasId';

    try {
      debugPrint('Sending data to API...');
      debugPrint('URL: $url');
      debugPrint('Payload: ${{
        'siswa': [
          {
            'id': siswaId,
            'nama': nama,
            'nomor_absen': nomor,
            'keterangan': status,
            'jam_absen': jamAbsen,
            'tanggal_absen': tanggalAbsen,
          }
        ]
      }}');

      final response = await dio.put(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'siswa': [
            {
              'id': siswaId,
              'nama': nama,
              'nomor_absen': nomor,
              'keterangan': status,
              'jam_absen': jamAbsen,
              'tanggal_absen': tanggalAbsen,
            }
          ]
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Data berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Gagal memperbarui data',
          'error': response.data,
        };
      }
    } catch (e) {
      debugPrint('Error during API call: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat menghubungi server.',
        'error': e.toString(),
      };
    }
  }
}
