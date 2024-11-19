import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Absenku.',
                style: GoogleFonts.poppins(
                  fontSize: 42, // Ukuran font lebih besar
                  fontWeight: FontWeight.w700, // Tebal sesuai desain
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16), // Jarak lebih kecil
              Text(
                'Login Sebagai Siapa?',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30), // Jarak antar elemen lebih kecil
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Tetap 2 kolom
                  crossAxisSpacing: 6, // Jarak antar kolom
                  mainAxisSpacing: 6, // Jarak antar baris
                ),
                children: [
                  _buildLoginOption(
                    icon: Icons.admin_panel_settings,
                    label: 'Admin',
                    onTap: () {
                      // Mengarahkan ke login.dart dengan role admin
                      Get.toNamed('/login', arguments: {'role': 'admin'});
                    },
                  ),
                  _buildLoginOption(
                    icon: Icons.school,
                    label: 'Siswa',
                    onTap: () {
                      // Mengarahkan ke login.dart dengan role siswa
                      Get.toNamed('/login', arguments: {'role': 'siswa'});
                    },
                  ),
                  _buildLoginOption(
                    icon: Icons.person,
                    label: 'Guru',
                    onTap: () {
                      // Mengarahkan ke login.dart dengan role guru
                      Get.toNamed('/login', arguments: {'role': 'guru'});
                    },
                  ),
                  _buildLoginOption(
                    icon: Icons.family_restroom,
                    label: 'Orang Tua',
                    onTap: () {
                      // Mengarahkan ke login.dart dengan role orang tua
                      Get.toNamed('/login', arguments: {'role': 'orangtua'});
                    },
                  ),
                ],
              ),
              SizedBox(height: 30), // Jarak antar elemen lebih kecil
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Background dengan transparansi
                  borderRadius: BorderRadius.circular(12), // Sudut melengkung
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10), // Padding teks
                child: Text(
                  'Selamat Datang',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120, // Ukuran kotak lebih besar
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Sudut persegi melengkung
            ),
            child: Icon(icon, size: 60, color: Colors.blueAccent), // Ikon lebih besar
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
