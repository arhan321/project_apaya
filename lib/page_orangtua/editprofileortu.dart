import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileOrtuPage extends StatefulWidget {
  final String namaLengkap;
  final String email;
  final String waliMurid;

  EditProfileOrtuPage({
    Key? key,
    this.namaLengkap = 'Udin Siregar',
    this.email = 'udin.siregar@email.com',
    this.waliMurid = 'Budiono Siregar',
  }) : super(key: key);

  @override
  _EditProfileOrtuPageState createState() => _EditProfileOrtuPageState();
}

class _EditProfileOrtuPageState extends State<EditProfileOrtuPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _waliMuridController;

  File? _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.namaLengkap);
    _emailController = TextEditingController(text: widget.email);
    _waliMuridController = TextEditingController(text: widget.waliMurid);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Mencegah resize layar saat keyboard muncul
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profil Orang Tua',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Pastikan full height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar Profile
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : AssetImage('assets/placeholder.jpg')
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.camera_alt, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Input Nama Lengkap
                  _buildLabel('Nama Lengkap'),
                  _buildInputField(_nameController),
                  SizedBox(height: 20),

                  // Input Email
                  _buildLabel('Email'),
                  _buildInputField(_emailController),
                  SizedBox(height: 20),

                  // Input Wali Murid
                  _buildLabel('Wali Murid'),
                  _buildInputField(_waliMuridController, enabled: false),
                  SizedBox(height: 40),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar('Berhasil', 'Data berhasil diperbarui!',
                            backgroundColor: Colors.greenAccent,
                            colorText: Colors.white);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Simpan Perubahan',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Warna teks menjadi putih
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
