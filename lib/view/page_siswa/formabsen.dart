import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '/controller/siswa_controller/formabsencontroller.dart';

class FormAbsenPage extends StatelessWidget {
  final int classId;
  final FormAbsenController controller = Get.put(FormAbsenController());

  FormAbsenPage({required this.classId}) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(
                controller: controller.idController, // Auto-generated ID
                hintText: 'ID Siswa (otomatis)',
                label: 'ID Siswa',
                keyboardType: TextInputType.number,
                enabled: false, // Disable editing
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: controller.nameController,
                hintText: 'Masukkan Nama',
                label: 'Nama',
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: controller.noAbsenController,
                hintText: 'Masukkan Nomor Absen',
                label: 'Nomor Absen',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: controller.kelasController,
                hintText: 'Masukkan Kelas',
                label: 'Kelas',
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: controller.jamAbsenController, // Auto-filled time
                hintText: 'Waktu absen (otomatis)',
                label: 'Jam Absen',
                enabled: false, // Disable editing
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: controller.catatanController,
                hintText: 'Masukkan Catatan (opsional)',
                label: 'Catatan',
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller:
                    controller.tanggalAbsenController, // Auto-filled date
                hintText: 'Tanggal absen (otomatis)',
                label: 'Tanggal Absen',
                enabled: false, // Disable editing
              ),
              SizedBox(height: 15),
              Obx(() => _buildDropdownField(
                    label: 'Keterangan Hadir',
                    options: controller.keteranganOptions,
                    value: controller.selectedKeterangan.value,
                    onChanged: (value) {
                      controller.selectedKeterangan.value = value!;
                    },
                  )),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => controller.submitAbsen(classId),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
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
        SizedBox(height: 5),
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
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
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
