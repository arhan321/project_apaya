import 'package:flutter/material.dart';
import 'package:forum/routes/routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAccountPage extends StatelessWidget {
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
          'Kelola Akun',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme:
            IconThemeData(color: Colors.white), // Ubah ikon panah menjadi putih
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Panah kembali
          onPressed: () {
            Get.back(); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildAccountCard(
                title: 'Akun Guru',
                subtitle: 'Kelola akun guru.',
                icon: Icons.person,
                onTap: () {
                  Get.toNamed(
                      '/listAkunGuru'); // Arahkan ke halaman List Akun Guru
                },
              ),
              SizedBox(height: 16),
              _buildAccountCard(
                title: 'Akun Siswa',
                subtitle: 'Kelola akun siswa.',
                icon: Icons.school,
                onTap: () {
                  Get.toNamed(
                      '/listAkunSiswa'); // Arahkan ke halaman List Akun Guru
                },
              ),
                SizedBox(height: 16),
              _buildAccountCard(
                title: 'Status Siswa akun siswa',
                subtitle: 'Cek Akun siswa yg bermasalah.',
                icon: Icons.school,
                onTap: () {
                  Get.toNamed(
                      '/statusAkunSiswa'); // Arahkan ke halaman List Akun Guru
                },
              ),
              SizedBox(height: 16),
              _buildAccountCard(
                title: 'Akun Orang Tua',
                subtitle: 'Kelola akun orang tua.',
                icon: Icons.family_restroom,
                onTap: () {
                  Get.toNamed(
                      '/listAkunOrtu'); // Arahkan ke halaman List Akun Guru
                },
              ),
              SizedBox(height: 16),
              _buildAccountCard(
                title: 'Akun Admin',
                subtitle: 'Kelola akun admin.',
                icon: Icons.admin_panel_settings,
                onTap: () {
                  Get.toNamed(
                      AppRoutes.listAkunAdmin); // Gunakan konstanta rute
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}