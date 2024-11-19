import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../page_global/login.dart'; // Pastikan jalur impor benar

class MainPageGuru extends StatelessWidget {
  final String userName;

  MainPageGuru({Key? key, this.userName = 'Guest'}) : super(key: key);

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
          'Dashboard Guru',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            color: Colors.white,
            onPressed: () {
              Get.snackbar(
                'Info',
                'Halaman Profile Guru belum tersedia.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16), // Tambahkan padding global
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero, // Hilangkan padding bawaan ListView
                children: [
                  _buildCard(
                    title: 'Jadwal Mengajar',
                    description: 'Lihat dan kelola jadwal mengajar Anda.',
                    icon: Icons.calendar_today,
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Halaman Jadwal Mengajar belum tersedia.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildCard(
                    title: 'Absensi Siswa',
                    description: 'Kelola absensi siswa Anda.',
                    icon: Icons.check_circle_outline,
                    onTap: () {
                      Get.snackbar(
                        'Info',
                        'Halaman Absensi Siswa belum tersedia.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],
              ),
            ),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            accountEmail: Text(
              '$userName@example.com',
              style: GoogleFonts.poppins(),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                userName.isNotEmpty ? userName[0] : 'G',
                style: GoogleFonts.poppins(
                  fontSize: 40.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blueAccent),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pop(context); // Tutup drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blueAccent),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Get.offAll(() => LoginScreen());
  }

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8), // Margin antar kartu
        padding: EdgeInsets.all(16), // Padding dalam kartu
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
              size: 40,
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Expanded( // Tambahkan Expanded agar teks tidak keluar batas
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
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
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

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.offAll(() => LoginScreen());
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Logout',
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
