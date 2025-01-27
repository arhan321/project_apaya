import 'dart:convert'; // Untuk decoding JSON string siswa
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ListAbsenOrtu extends StatefulWidget {
  final int classId; // Parameter untuk ID kelas

  const ListAbsenOrtu({Key? key, required this.classId}) : super(key: key);

  @override
  _ListAbsenOrtuState createState() => _ListAbsenOrtuState();
}

class _ListAbsenOrtuState extends State<ListAbsenOrtu> {
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
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final List<String> daysInWeek = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final String dayOfWeek = daysInWeek[now.weekday % 7];

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
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Get.toNamed('/profilOrtu');
            },
          ),
        ],
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang Wali Murid',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Udin Siregar',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                dayOfWeek,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return AbsenCard(
                            name: student['nama'] ?? 'Tidak diketahui',
                            number: 'No ${student['nomor_absen'] ?? '-'}',
                            status: student['keterangan'] ?? 'Tidak diketahui',
                            statusColor: _getStatusColor(
                                student['keterangan'] ?? 'Tidak diketahui'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hadir':
        return Colors.green;
      case 'Sakit':
        return Colors.blue;
      case 'Izin':
        return Colors.orange;
      case 'Tidak Hadir':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class AbsenCard extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final String number;

  const AbsenCard({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
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
                    Get.toNamed(
                      '/detailAbsenOrtu',
                      arguments: {
                        'name': name,
                        'number': number,
                        'status': status,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      '/cekCatatan',
                      arguments: {
                        'name': name,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cek Catatan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
