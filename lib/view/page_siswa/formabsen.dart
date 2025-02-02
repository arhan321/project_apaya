import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controller/siswa_controller/formabsencontroller.dart';

class FormAbsenPage extends StatelessWidget {
  final int classId;
  final FormAbsenController controller = Get.put(FormAbsenController());

  FormAbsenPage({Key? key, required this.classId}) : super(key: key) {
    // Generate random ID
    controller.idController.text = Random().nextInt(100000).toString();

    // Set current time and date
    final now = DateTime.now();
    controller.jamAbsenController.text =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    controller.tanggalAbsenController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    // Clear catatan
    controller.catatanController.text = "";
    // Fetch classes from API
    controller.fetchClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Form Absen',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Nama Siswa
              _buildTextField(
                controller: controller.nameController,
                hintText: 'Masukkan Nama',
                label: 'Nama',
              ),
              const SizedBox(height: 15),

              // Nomor Absen
              _buildTextField(
                controller: controller.noAbsenController,
                hintText: 'Masukkan Nomor Absen',
                label: 'Nomor Absen',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              // Dropdown Kelas
              Obx(
                () => _buildDropdownField(
                  label: 'Kelas',
                  options: controller.kelasOptions,
                  value: controller.selectedKelas.value,
                  onChanged: (value) {
                    controller.selectedKelas.value = value!;
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Jam Absen
              _buildTextField(
                controller: controller.jamAbsenController,
                hintText: 'Waktu absen (otomatis)',
                label: 'Jam Absen',
                enabled: false,
              ),
              const SizedBox(height: 15),

              // Tanggal Absen
              _buildTextField(
                controller: controller.tanggalAbsenController,
                hintText: 'Tanggal absen (otomatis)',
                label: 'Tanggal Absen',
                enabled: false,
              ),
              const SizedBox(height: 15),

              // Dropdown Keterangan
              Obx(
                () => _buildDropdownField(
                  label: 'Keterangan Hadir',
                  options: controller.keteranganOptions,
                  value: controller.selectedKeterangan.value,
                  onChanged: (value) {
                    controller.selectedKeterangan.value = value!;
                  },
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () => controller.submitAbsen(classId),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> options,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
