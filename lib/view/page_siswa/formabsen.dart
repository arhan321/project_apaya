import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controller/siswa_controller/formabsencontroller.dart';

class FormAbsenPage extends StatelessWidget {
  final int classId;
  final FormAbsenController controller = Get.put(FormAbsenController());

  FormAbsenPage({required this.classId});

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
                controller: controller.idController, // Tambahkan form ID
                hintText: 'Masukkan ID Siswa (opsional)',
                label: 'ID Siswa',
                keyboardType: TextInputType.number,
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
              _buildTimePickerField(
                context: context,
                controller: controller.jamAbsenController,
                label: 'Jam Absen',
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: controller.catatanController,
                hintText: 'Masukkan Catatan (opsional)',
                label: 'Catatan',
              ),
              SizedBox(height: 15),
              _buildDatePickerField(
                context: context,
                controller: controller.tanggalAbsenController,
                label: 'Tanggal Absen',
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

  Widget _buildTimePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
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
        GestureDetector(
          onTap: () async {
            final timeOfDay = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (timeOfDay != null) {
              controller.text = timeOfDay.format(context);
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Pilih waktu (HH:mm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
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
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              controller.text = "${date.year}-${date.month}-${date.day}";
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Pilih tanggal (yyyy-MM-dd)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
