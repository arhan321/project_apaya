import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAbsenAdminPage extends StatelessWidget {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController jamAbsenController = TextEditingController();
  final List<String> statusList = ['Hadir', 'Sakit', 'Izin', 'Tidak Hadir'];

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    final arguments = Get.arguments ?? {};
    namaController.text = arguments['name'] ?? '';
    nomorController.text = arguments['number'] ?? '';
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
            _buildTextField('Nomor', nomorController),
            SizedBox(height: 12),
            _buildDropdown('Status Absensi', selectedStatus, statusList,
                (value) {
              selectedStatus = value!;
            }),
            SizedBox(height: 12),
            _buildTextField('Jam Absen', jamAbsenController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.snackbar('Berhasil', 'Data absensi berhasil disimpan');
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
}
