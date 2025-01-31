import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../';
// ^^^ ganti 'your_app_name' sesuai package Anda

class TambahAbsenPage extends StatelessWidget {
  final int classId; // classId yang dikirim dari route

  const TambahAbsenPage({Key? key, required this.classId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memasukkan controller ke dalam GetX
    // Anda bisa pakai Get.put jika ini pertama kali inject
    final TambahAbsenController c = Get.put(TambahAbsenController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Absen',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        // Gunakan Obx untuk memantau isLoading di controller
        return c.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Absensi Baru (classId = $classId)',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),

                      // ID Siswa
                      _buildTextField(
                        controller: c.idController,
                        label: 'ID Siswa (Otomatis)',
                        hint: '',
                        enabled: false,
                      ),
                      SizedBox(height: 16),

                      // Nama Siswa
                      _buildTextField(
                        controller: c.nameController,
                        label: 'Nama Siswa',
                        hint: 'Masukkan nama siswa',
                      ),
                      SizedBox(height: 16),

                      // Nomor Absen
                      _buildTextField(
                        controller: c.noAbsenController,
                        label: 'Nomor Absen',
                        hint: 'Masukkan nomor absen',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),

                      // Pilih Kelas
                      Text(
                        'Pilih Kelas',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                            value: c.kelasOptions.isNotEmpty
                                ? c.selectedKelas.value
                                : null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: c.kelasOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                c.selectedKelas.value = newValue;
                              }
                            },
                          )),
                      SizedBox(height: 16),

                      // Jam Absen
                      _buildTextField(
                        controller: c.jamAbsenController,
                        label: 'Jam Absen',
                        hint: '',
                        enabled: false,
                      ),
                      SizedBox(height: 16),

                      // Tanggal Absen
                      _buildTextField(
                        controller: c.tanggalAbsenController,
                        label: 'Tanggal Absen',
                        hint: '',
                        enabled: false,
                      ),
                      SizedBox(height: 16),

                      // Keterangan Absensi
                      Text(
                        'Keterangan Absensi',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                            value: c.selectedKeterangan.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: c.keteranganOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                c.selectedKeterangan.value = newValue;
                              }
                            },
                          )),
                      SizedBox(height: 16),

                      // Catatan (Opsional)
                      _buildTextField(
                        controller: c.catatanController,
                        label: 'Catatan (Opsional)',
                        hint: 'Tambahkan catatan jika diperlukan',
                        maxLines: 3,
                        enabled: true,
                      ),
                      SizedBox(height: 24),

                      // Tombol Simpan
                      Center(
                        child: ElevatedButton(
                          onPressed: () => c.submitAbsen(classId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Simpan Absen',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  // Helper untuk membuat TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
