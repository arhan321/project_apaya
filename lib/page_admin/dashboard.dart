import 'package:flutter/material.dart';
import 'package:forum/routes/routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboard extends StatelessWidget {
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
          'Dashboard Admin',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context), // Drawer
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
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: MediaQuery.of(context).size.width < 600
                      ? 3
                      : 2.5, // Sesuaikan rasio
                  children: [
                    _buildFeatureCard(
                      context,
                      title: 'Tambah Kelas',
                      subtitle: 'Tambahkan kelas baru dan edit ke sistem.',
                      icon: Icons.class_,
                      route: '/daftarKelas', // Rute untuk Tambah Kelas
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Kelola Pengguna',
                      subtitle: 'Tambah, ubah, atau hapus pengguna.',
                      icon: Icons.people,
                      route: '/listAccount', // Rute untuk List Account
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Kelola Absensi',
                      subtitle: 'Pantau dan ubah data absensi.',
                      icon: Icons.checklist,
                      route: '/kelolaAbsensi',
                    ),
                    _buildFeatureCard(
                      context,
                      title: 'Laporan',
                      subtitle: 'Lihat dan unduh laporan absensi.',
                      icon: Icons.insert_chart,
                    ),
                  ],
                ),
              ),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Admin',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              'admin@example.com',
              style: GoogleFonts.poppins(
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'A',
                style: GoogleFonts.poppins(
                  fontSize: 40.0,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blueAccent),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pop(context); // Tutup Drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.class_, color: Colors.blueAccent),
            title: Text(
              'Tambah Kelas',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.daftarKelas);
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.blueAccent),
            title: Text(
              'Kelola Pengguna',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.toNamed('/listAccount'); // Navigasi ke List Account
            },
          ),
          ListTile(
            leading: Icon(Icons.checklist, color: Colors.blueAccent),
            title: Text(
              'Kelola Absensi',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.snackbar(
                'Info',
                'Fitur Kelola Absensi belum tersedia.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_chart, color: Colors.blueAccent),
            title: Text(
              'Laporan',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.snackbar(
                'Info',
                'Fitur Laporan belum tersedia.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blueAccent),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Get.offAllNamed('/login'); // Kembali ke halaman login
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    String? route,
  }) {
    return InkWell(
      onTap: () {
        if (route != null) {
          Get.toNamed(route); // Navigasi ke rute tertentu
        } else {
          Get.snackbar(
            'Info',
            'Fitur $title belum tersedia.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
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

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.offAllNamed('/login'); // Kembali ke halaman login
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
