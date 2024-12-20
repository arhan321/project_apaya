import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FormAbsenPage extends StatefulWidget {
  @override
  _FormAbsenPageState createState() => _FormAbsenPageState();
}

class _FormAbsenPageState extends State<FormAbsenPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noAbsenController = TextEditingController();
  String selectedKeterangan = 'Hadir'; // Default value
  final TextEditingController kelasController = TextEditingController();

  final List<String> keteranganOptions = [
    'Hadir',
    'Izin',
    'Sakit',
    'Tidak Hadir'
  ];

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: nameController,
                hintText: 'Masukkan Nama',
                label: 'Nama',
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: noAbsenController,
                hintText: 'Masukkan Nomor Absen',
                label: 'Nomor Absen',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 15),
              _buildDropdownField(
                label: 'Keterangan Hadir',
                options: keteranganOptions,
                value: selectedKeterangan,
                onChanged: (value) {
                  setState(() {
                    selectedKeterangan = value!;
                  });
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: kelasController,
                hintText: 'Masukkan Kelas',
                label: 'Kelas',
              ),
              SizedBox(height: 30),
              _buildSubmitButton(),
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
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
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
            color: Colors.white,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option, style: GoogleFonts.poppins(fontSize: 14)),
              );
            }).toList(),
            onChanged: onChanged,
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (nameController.text.isEmpty ||
              noAbsenController.text.isEmpty ||
              kelasController.text.isEmpty) {
            Get.snackbar(
              'Error',
              'Semua field harus diisi!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            return;
          }

          Get.snackbar(
            'Sukses',
            'Absen berhasil disimpan!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Absen',
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
