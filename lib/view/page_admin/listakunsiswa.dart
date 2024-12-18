import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAkunSiswa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Contoh data untuk akun siswa
    final List<Map<String, String>> akunSiswa = [
      {
        'foto': 'https://via.placeholder.com/150', // Ganti dengan URL foto asli
        'nama': 'Ilham Wijaya',
        'username': 'ilham_wijaya',
        'email': 'ilham@siswa.com',
        'password': '********',
        'role': 'Siswa',
        'no_absen': '01',
      },
      {
        'foto': 'https://via.placeholder.com/150', // Ganti dengan URL foto asli
        'nama': 'Rini Andriani',
        'username': 'rini_andriani',
        'email': 'rini@siswa.com',
        'password': '********',
        'role': 'Siswa',
        'no_absen': '02',
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
          'Daftar Akun Siswa',
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
          itemCount: akunSiswa.length,
          itemBuilder: (context, index) {
            final akun = akunSiswa[index];
            return _buildAkunCard(
              context,
              foto: akun['foto']!,
              nama: akun['nama']!,
              username: akun['username']!,
              email: akun['email']!,
              password: akun['password']!,
              role: akun['role']!,
              noAbsen: akun['no_absen']!,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/tambahAkunSiswa'); // Arahkan ke halaman Tambah Akun Siswa
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
    required String noAbsen,
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
                    'No. Absen: $noAbsen',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
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
                Get.toNamed('/editAkunSiswa', arguments: {
                  'foto': foto,
                  'nama': nama,
                  'username': username,
                  'email': email,
                  'password': password,
                  'role': role,
                  'no_absen': noAbsen,
                }); // Arahkan ke halaman Edit Akun Siswa
              },
            ),
          ],
        ),
      ),
    );
  }
}
