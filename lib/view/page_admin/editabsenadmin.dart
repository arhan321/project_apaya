import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class EditAbsenAdminPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController jamAbsenController = TextEditingController();
  final List<String> statusList = ['Hadir', 'Sakit', 'Izin', 'Tidak Hadir'];

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    final arguments = Get.arguments ?? {};
    final int kelasId = arguments['kelasId'] ?? 0; // ID kelas
    final int siswaId = arguments['siswaId'] ?? 0; // ID siswa
    namaController.text = arguments['name'] ?? '';
    // Hanya ambil angka dari nomor absen
    nomorController.text =
        (arguments['number'] ?? '').replaceAll('No Absen ', '');
    jamAbsenController.text = arguments['jamAbsen'] ?? '';
    String selectedStatus = arguments['status'] ?? 'Hadir';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Edit Absen',
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
          children: [
            _buildTextField('Nama Siswa', namaController),
            SizedBox(height: 12),
            _buildTextField('Nomor Absen', nomorController), // Ubah label
            SizedBox(height: 12),
            _buildDropdown('Status Absensi', selectedStatus, statusList,
                (value) {
              selectedStatus = value!;
            }),
            SizedBox(height: 12),
            _buildTextField('Jam Absen', jamAbsenController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final response = await _updateAbsen(
                  kelasId: kelasId,
                  siswaId: siswaId,
                  nama: namaController.text,
                  nomorAbsen: nomorController.text,
                  jamAbsen: jamAbsenController.text,
                  status: selectedStatus,
                );

                if (response['success']) {
                  Get.snackbar(
                    'Berhasil',
                    response['message'],
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  Get.back(); // Kembali ke halaman sebelumnya
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
                    borderRadius: BorderRadius.circular(10)),
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

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
    required String nomorAbsen,
    required String jamAbsen,
    required String status,
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
            'nomor_absen': nomorAbsen,
            'keterangan': status,
            'jam_absen': jamAbsen,
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
              'nomor_absen': nomorAbsen,
              'keterangan': status,
              'jam_absen': jamAbsen,
            }
          ],
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
