import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controller/orangtua_controller/editprofileortu_controller.dart';

class EditProfileOrtuPage extends StatelessWidget {
  final controller = Get.put(EditProfileOrtuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          'Edit Profil Orang Tua',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: true); // Kembali dengan hasil true
          },
        ),
      ),
      body: GetBuilder<EditProfileOrtuController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _.imageFile != null
                            ? FileImage(_.imageFile!)
                            : (_.imageUrl != null
                                ? NetworkImage(_.imageUrl!)
                                : null),
                        child: _.imageFile == null && _.imageUrl == null
                            ? Text(
                                'Foto Kosong',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _.pickImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 20,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                _buildInputField('Nama Lengkap', _.nameController),
                SizedBox(height: 20),
                _buildInputField('Email', _.emailController),
                SizedBox(height: 20),
                _buildInputField('Wali Murid', _.waliMuridController,
                    isEnabled: false),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  ),
                  child: Text("Simpan Perubahan",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _.uploadPhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  ),
                  child: Text("Upload Foto",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isEnabled = true}) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
