import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'editabsen.dart'; // Import halaman EditAbsenPage
import '../page_guru/profileguru.dart'; // Pastikan ini mengimpor halaman ProfileGuruPage

class ListAbsenSiswaPage extends StatelessWidget {
  final String className;

  ListAbsenSiswaPage({required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Absenku.',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle), // Icon person di pojok kanan atas
            onPressed: () {
              // Navigasi ke halaman profile guru
              Get.to(() => ProfileGuruPage(
                guruName: 'Tatang Sutarman', // Nama guru
                kelas: 'Kelas 6A', // Kelas yang diajar
                waliKelas: 'Tatang Sutarman', // Nama wali kelas
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Container untuk menampilkan nama guru dan kolom pencarian
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.blueAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Tatang Sutarman', // Nama guru
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                // Kolom pencarian nama
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Nama?',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Menampilkan tanggal saat ini
                Text(
                  DateTime.now().toString().split(' ')[0], // Menampilkan tanggal
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildAbsenTile(
                  name: 'Randi Praditiya',
                  number: 'No 1',
                  badge: 'Hadir',
                  jamAbsen: '08:30',
                ),
                _buildAbsenTile(
                  name: 'Putra Dewantara',
                  number: 'No 2',
                  badge: 'Sakit',
                  jamAbsen: '08:45',
                ),
                _buildAbsenTile(
                  name: 'Adi Santoso',
                  number: 'No 3',
                  badge: 'Izin',
                  jamAbsen: '09:00',
                ),
                _buildAbsenTile(
                  name: 'Wahyu Kurniawan',
                  number: 'No 4',
                  badge: 'Tidak Hadir',
                  jamAbsen: 'Tidak Ada',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenTile({
    required String name,
    required String number,
    required String badge,
    required String jamAbsen,
  }) {
    Color badgeColor;
    switch (badge) {
      case 'Hadir':
        badgeColor = Colors.green;
        break;
      case 'Izin':
        badgeColor = Colors.orange;
        break;
      case 'Sakit':
        badgeColor = Colors.blue;
        break;
      case 'Tidak Hadir':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              number,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Detail
            ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  '/viewDetail', // Arahkan ke halaman detail siswa
                  arguments: {
                    'name': name,
                    'number': number,
                    'kelas': className,
                    'keterangan': badge,
                    'jamAbsen': jamAbsen,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Lihat Detail', // Mengubah teks button menjadi 'Lihat Detail'
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 8), // Jarak antar tombol
            // Tombol Edit
            ElevatedButton(
              onPressed: () {
                Get.to(
                  () => EditAbsenPage(),
                  arguments: {
                    'name': name,
                    'number': number,
                    'badge': badge,
                    'jamAbsen': jamAbsen,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
