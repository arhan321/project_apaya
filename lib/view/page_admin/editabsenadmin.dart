import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/admin_controller/kelolakelasadmin_controller/editabsenadmin_controller.dart';

class EditAbsenAdminPage extends StatelessWidget {
  /// Inisialisasi controller dengan Get.put
  final EditAbsenAdminController controller =
      Get.put(EditAbsenAdminController());

  /// TextEditingController untuk form
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController jamAbsenController = TextEditingController();
  final TextEditingController tanggalAbsenController = TextEditingController();

  final List<String> statusList = ['Hadir', 'Sakit', 'Izin', 'Tidak Hadir'];

  EditAbsenAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments
    final arguments = Get.arguments ?? {};
    final int kelasId = arguments['kelasId'] ?? 0; // ID kelas
    final int siswaId = arguments['siswaId'] ?? 0; // ID siswa

    // Isi controller textfield
    namaController.text = arguments['name'] ?? '';
    // Nomor absen, hapus "No Absen " jika ada
    nomorController.text =
        (arguments['number'] ?? '').replaceAll('No Absen ', '');
    jamAbsenController.text = arguments['jamAbsen'] ?? '';
    tanggalAbsenController.text = arguments['tanggalAbsen'] ?? '';
    // Nilai default selectedStatus
    String selectedStatus = arguments['status'] ?? 'Hadir';

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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Nama Siswa', namaController),
            const SizedBox(height: 12),
            _buildTextField('Nomor Absen', nomorController),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Status Absensi',
              value: selectedStatus,
              items: statusList,
              onChanged: (value) {
                // Harus kita simpan ke selectedStatus
                if (value != null) {
                  selectedStatus = value;
                }
              },
            ),
            const SizedBox(height: 12),
            _buildTextField('Jam Absen', jamAbsenController),
            const SizedBox(height: 12),
            _buildTextField('Tanggal Absen', tanggalAbsenController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Panggil controller.updateAbsen
                final response = await controller.updateAbsen(
                  kelasId: kelasId,
                  siswaId: siswaId,
                  nama: namaController.text,
                  nomorAbsen: nomorController.text,
                  jamAbsen: jamAbsenController.text,
                  status: selectedStatus,
                  tanggalAbsen: tanggalAbsenController.text,
                );

                if (response['success'] == true) {
                  Get.snackbar(
                    'Berhasil',
                    'Data absensi berhasil diperbarui',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  // Tambahkan delay jika mau
                  await Future.delayed(const Duration(seconds: 1));
                  Get.back(result: true); // Kembali & berikan indikasi success
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
                padding: const EdgeInsets.symmetric(vertical: 12),
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

  /// Widget helper: TextField
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

  /// Widget helper: Dropdown
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
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
