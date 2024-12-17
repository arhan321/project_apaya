import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noAbsenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final role = Get.arguments?['role'] ?? 'siswa'; // Ambil role

    String headerText = _getHeaderText(role);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.off(() => LoginScreen(),
                            arguments: {'role': role});
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      headerText,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Daftar untuk memulai!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(Icons.person, 'Nama Lengkap'),
                  SizedBox(height: 20),
                  _buildTextField(Icons.person_outline, 'Username'),
                  SizedBox(height: 20),
                  _buildTextField(Icons.email, 'Email'),
                  SizedBox(height: 20),
                  _buildTextField(Icons.lock, 'Password', isPassword: true),
                  SizedBox(height: 20),
                  _buildTextField(Icons.lock_outline, 'Konfirmasi Password',
                      isPassword: true),
                  if (role == 'siswa') ...[
                    SizedBox(height: 20),
                    _buildTextField(Icons.format_list_numbered, 'Nomor Absen'),
                  ],
                  SizedBox(height: 30),
                  _buildRegisterButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getHeaderText(String role) {
    switch (role) {
      case 'admin':
        return 'Daftar sebagai Admin';
      case 'guru':
        return 'Daftar sebagai Guru';
      case 'orangtua':
        return 'Daftar sebagai Orang Tua';
      default:
        return 'Daftar sebagai Siswa';
    }
  }

  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: GoogleFonts.poppins(),
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Logika register
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Daftar',
          style: GoogleFonts.poppins(
            color: Colors.purpleAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
