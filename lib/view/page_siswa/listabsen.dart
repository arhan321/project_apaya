import 'dart:convert'; // Untuk decoding JSON string siswa
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAbsenPage extends StatefulWidget {
  final int classId; // Tambahkan ID kelas sebagai parameter

  ListAbsenPage({required this.classId});

  @override
  _ListAbsenPageState createState() => _ListAbsenPageState();
}

class _ListAbsenPageState extends State<ListAbsenPage> {
  bool isLoading = true;
  String errorMessage = '';
  String className = '';
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchClassData(widget.classId);
  }

  Future<void> fetchClassData(int classId) async {
    const String urlBase = 'https://absen.randijourney.my.id/api/v1/kelas/';
    final String url = '$urlBase$classId';

    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final response = await GetConnect().get(url);

      if (response.statusCode == 200) {
        final data = response.body['data'];

        setState(() {
          className = data['nama_kelas'] ?? 'Tidak diketahui';
          students = (jsonDecode(data['siswa']) as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Gagal memuat data. Status Code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan saat memuat data.';
        isLoading = false;
      });
    }
  }

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
          'Absen $className',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      color: Colors.blueAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Kelas:',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            className,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            DateTime.now().toString().split(' ')[0],
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
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return _buildAbsenCard(
                            name: student['nama'] ?? 'Tidak diketahui',
                            number: 'No ${student['nomor_absen'] ?? '-'}',
                            badge: student['keterangan'] ?? 'Tidak diketahui',
                            jamAbsen: student['jam_absen'] ?? '-',
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            print(
                                'Navigating to FormAbsenPage with classId: ${widget.classId}');
                            Get.toNamed('/formAbsen',
                                arguments: {'classId': widget.classId});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Silahkan Absen',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildAbsenCard({
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
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    number,
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: badgeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(
                '/viewDetail',
                arguments: {
                  'name': name,
                  'number': number,
                  'kelas': className, // Tambahkan kelas
                  'keterangan': badge,
                  'jamAbsen': jamAbsen,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Lihat Detail',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
