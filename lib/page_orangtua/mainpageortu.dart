import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:forum/page_orangtua/listabsenortu.dart'; // Impor ListAbsenOrtu
import 'profilortu.dart'; // Impor ProfilortuPage
import '../page_global/login.dart'; // Impor LoginScreen

class MainPageOrtu extends StatelessWidget {
  final String userName;

  MainPageOrtu({Key? key, this.userName = 'Orang Tua'}) : super(key: key);

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
          'Dashboard Orang Tua',
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
              // Navigasi ke halaman ProfilortuPage
              Get.to(() => ProfilortuPage(
                    orangTuaName: 'Udin Siregar', // Contoh nama orang tua
                    waliMurid: 'Budiono Siregar', // Nama wali murid
                    email: 'udin@ortu.com',       // Contoh email
                  ));
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context), // Menambahkan kembali Drawer
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
                child: ListView(
                  children: [
                    _buildCard(
                      title: 'Kelas 6A',
                      subtitle: 'SD NEGERI RANCAGONG 1',
                      teacher: 'Tatang Sutarman',
                      onTap: () {
                        Get.to(() => ListAbsenOrtu()); // Arahkan ke ListAbsenOrtu
                      },
                    ),
                    SizedBox(height: 10),
                    _buildCard(
                      title: 'Kelas 6B',
                      subtitle: 'SD NEGERI RANCAGONG 1',
                      teacher: 'Budiono Siregar',
                      onTap: () {
                        Get.to(() => ListAbsenOrtu()); // Arahkan ke ListAbsenOrtu
                      },
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
                userName.isNotEmpty ? userName[0] : 'G', // Gunakan 'G' jika userName kosong
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
    Get.offAll(() => LoginScreen()); // Menghapus semua halaman sebelumnya dan kembali ke halaman login
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String teacher,
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
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              teacher,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.white,
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
          Get.offAll(() => LoginScreen()); // Menghapus semua halaman sebelumnya dan kembali ke halaman login
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Logout',
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
