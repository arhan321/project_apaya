import 'package:flutter/material.dart';
import 'package:forum/page_guru/editabsen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'catatanguru.dart'; // Pastikan untuk mengimpor halaman CatatanGuruPage

class ListAbsenSiswaPage extends StatelessWidget {
  final String className;

  ListAbsenSiswaPage({required this.className});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final List<String> daysOfWeek = [
      'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
    ];
    final String dayName = daysOfWeek[now.weekday % 7];

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
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  'Tatang Sutarman',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      dayName,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Cari Nama Siswa',
                          hintStyle: GoogleFonts.poppins(fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        // Logika filter, bisa ditambahkan sesuai kebutuhan
                        print("Filter icon clicked");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildAbsenCard('Ilham God', 'No 1', 'Hadir', Colors.green, '08:30'),
                _buildAbsenCard('Putra Dewantara', 'No 2', 'Sakit', Colors.blue, '08:45'),
                _buildAbsenCard('Adi Santoso', 'No 3', 'Izin', Colors.orange, '09:00'),
                _buildAbsenCard('Wahyu Kurniawan', 'No 4', 'Tidak Hadir', Colors.red, 'Tidak Ada'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenCard(String name, String number, String status, Color statusColor, String jamAbsen) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Text(
                    number,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/viewDetail', arguments: {'name': name, 'number': number, 'kelas': className, 'keterangan': status, 'jamAbsen': jamAbsen});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Lihat Detail', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => EditAbsenPage(), arguments: {'name': name, 'number': number, 'badge': status, 'jamAbsen': jamAbsen});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Edit', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Kirim nama siswa ke halaman CatatanGuruPage
                Get.toNamed('/catatanGuru', arguments: {'name': name});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Beri Catatan', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
