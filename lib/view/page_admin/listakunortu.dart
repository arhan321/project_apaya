import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAkunOrtu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Contoh data untuk akun orang tua
    final List<Map<String, String>> akunOrtu = [
      {
        'foto': 'https://via.placeholder.com/150', // Ganti dengan URL foto asli
        'nama': 'Budi Santoso',
        'username': 'budi_santoso',
        'email': 'budi@ortu.com',
        'password': '********',
        'role': 'Orang Tua',
      },
      {
        'foto': 'https://via.placeholder.com/150', // Ganti dengan URL foto asli
        'nama': 'Siti Aisyah',
        'username': 'siti_aisyah',
        'email': 'siti@ortu.com',
        'password': '********',
        'role': 'Orang Tua',
      },
    ];

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
          'Daftar Akun Orang Tua',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
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
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: akunOrtu.length,
          itemBuilder: (context, index) {
            final akun = akunOrtu[index];
            return _buildAkunCard(
              context,
              foto: akun['foto']!,
              nama: akun['nama']!,
              username: akun['username']!,
              email: akun['email']!,
              password: akun['password']!,
              role: akun['role']!,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/tambahAkunOrtu'); // Arahkan ke halaman Tambah Akun Orang Tua
        },
        label: Text(
          'Tambah Akun',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildAkunCard(
    BuildContext context, {
    required String foto,
    required String nama,
    required String username,
    required String email,
    required String password,
    required String role,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(foto),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Username: $username',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Email: $email',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Password: $password',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Role: $role',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                Get.toNamed('/editAkunOrtu', arguments: {
                  'foto': foto,
                  'nama': nama,
                  'username': username,
                  'email': email,
                  'password': password,
                  'role': role,
                }); // Arahkan ke halaman Edit Akun Orang Tua
              },
            ),
          ],
        ),
      ),
    );
  }
}
