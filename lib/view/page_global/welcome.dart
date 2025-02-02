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
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Absenku',
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Login Sebagai Siapa?',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  _buildRoleButton(
                    label: 'Admin',
                    icon: Icons.admin_panel_settings,
                    role: 'admin',
                  ),
                  _buildRoleButton(
                    label: 'Guru',
                    icon: Icons.school,
                    role: 'guru',
                  ),
                  _buildRoleButton(
                    label: 'Siswa',
                    icon: Icons.person,
                    role: 'siswa',
                  ),
                  _buildRoleButton(
                    label: 'Orang Tua',
                    icon: Icons.family_restroom,
                    role: 'orangtua',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String label,
    required IconData icon,
    required String role,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/login', arguments: {'role': role});
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 50, color: Colors.blueAccent),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
