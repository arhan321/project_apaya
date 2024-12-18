import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/routes/routes.dart';
import '../../controller/global_controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
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
                          // Standar logika dari kode sebelumnya
                          Get.back(); // Tutup halaman saat ini
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Teks Header
                    Text(
                      'Selamat Datang',
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Masuk ke akun Anda',
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Input Email
                    _buildTextField(
                      controller: loginController.emailController,
                      icon: Icons.email,
                      hint: 'Email',
                    ),
                    const SizedBox(height: 20),
                    // Input Password
                    _buildTextField(
                      controller: loginController.passwordController,
                      icon: Icons.lock,
                      hint: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    // Tombol Login
                    Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loginController.isLoading.value
                              ? null
                              : () => loginController.login(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: loginController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                )
                              : Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blueAccent,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    }),
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
