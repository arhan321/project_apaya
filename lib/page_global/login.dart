import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final role = Get.arguments?['role'] ?? 'guest'; // Ambil role dari argument

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Latar belakang gradasi
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Konten halaman login
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tombol Back
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.welcome);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // Teks Header
                    Text(
                      'Selamat Datang',
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Masuk ke akun Anda',
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 40),
                    // Input Username
                    _buildTextField(
                      controller: usernameController,
                      icon: Icons.person,
                      hint: 'Username',
                    ),
                    SizedBox(height: 20),
                    // Input Password
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          controller: passwordController,
                          icon: Icons.lock,
                          hint: 'Password',
                          isPassword: true,
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              'Lupa Password?',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // Tombol Login
                    _buildLoginButton(context, role),
                    SizedBox(height: 20),
                    // Navigasi ke Halaman Register
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.register, arguments: {'role': role});
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Belum punya akun? ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.normal, // Tidak bold
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Daftar di sini',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold, // Bold
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Input Field
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  // Widget untuk Tombol Login
  Widget _buildLoginButton(BuildContext context, String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (role == 'guru') {
            Get.offAllNamed(AppRoutes.mainPageGuru);
          } else if (role == 'siswa') {
            Get.offAllNamed(AppRoutes.mainPage);
          } else if (role == 'orangtua') {
            Get.offAllNamed(AppRoutes.mainPageOrtu);
          } else if (role == 'admin') {
            Get.offAllNamed('/adminDashboard'); // Navigasi ke admin dashboard
          } else {
            Get.snackbar(
              'Error',
              'Role tidak dikenali!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Login',
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: MediaQuery.of(context).size.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
