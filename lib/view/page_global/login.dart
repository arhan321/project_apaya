import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/routes/routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs; // State untuk tombol loading

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
                          Get.offAllNamed(AppRoutes.welcome);
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
                      controller: emailController,
                      icon: Icons.email,
                      hint: 'Email',
                    ),
                    const SizedBox(height: 20),
                    // Input Password
                    _buildTextField(
                      controller: passwordController,
                      icon: Icons.lock,
                      hint: 'Password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    // Tombol Login
                    Obx(() => _buildLoginButton(context)),
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

  // Widget untuk Tombol Login
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading.value ? null : () => _login(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isLoading.value
            ? const CircularProgressIndicator(color: Colors.blueAccent)
            : Text(
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

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Password tidak boleh kosong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);
      print('Mengirim request ke server...');

      final response = await http.post(
        Uri.parse('https://absen.djncloud.my.id/api/v1/account/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Koneksi timeout, coba lagi nanti.');
      });

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ambil role dari user object
        final role = data['user']?['role'];
        if (role != null) {
          Get.snackbar(
            'Success',
            'Login Berhasil!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent,
            colorText: Colors.white,
          );
          _navigateBasedOnRole(role);
        } else {
          Get.snackbar(
            'Error',
            'Role tidak ditemukan dalam respons.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        final error = json.decode(response.body);
        final errorMessage = error['message'] ?? 'Login gagal!';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Navigasi berdasarkan Role
  void _navigateBasedOnRole(String role) {
    if (role == 'guru') {
      Get.offAllNamed(AppRoutes.mainPageGuru);
    } else if (role == 'siswa') {
      Get.offAllNamed(AppRoutes.mainPage);
    } else if (role == 'orang_tua') {
      Get.offAllNamed(AppRoutes.mainPageOrtu);
    } else if (role == 'admin') {
      Get.offAllNamed('/adminDashboard');
    } else {
      Get.snackbar(
        'Error',
        'Role tidak dikenali!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
