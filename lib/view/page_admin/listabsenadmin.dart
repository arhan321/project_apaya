import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ListAbsenAdminPage extends StatefulWidget {
  @override
  _ListAbsenAdminPageState createState() => _ListAbsenAdminPageState();
}

class _ListAbsenAdminPageState extends State<ListAbsenAdminPage> {
  List<dynamic> siswaAbsen = [];
  bool isLoading = true;
  int? selectedClassId;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments ?? {};
    debugPrint('Arguments received: $arguments'); // Debugging log
    selectedClassId = arguments['id']; // Ambil ID kelas dari arguments
    if (selectedClassId == null) {
      debugPrint('Error: selectedClassId is null.');
      Get.snackbar(
        'Error',
        'ID kelas tidak ditemukan. Harap pilih kelas yang valid.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (selectedClassId == null) {
      debugPrint('Error: selectedClassId is null. Skipping fetch.');
      setState(() {
        siswaAbsen = [];
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http
          .get(Uri.parse('https://absen.djncloud.my.id/api/v1/kelas'));
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('Decoded response: $responseData');

        final List<dynamic> kelasData = responseData['data'];
        debugPrint('Kelas data: $kelasData');

        // Cari kelas dengan ID tertentu
        final Map<String, dynamic>? kelas = kelasData.firstWhere(
          (kelas) {
            final int kelasId = int.tryParse(kelas['id'].toString()) ?? 0;
            debugPrint(
                'Checking kelas ID: $kelasId with selected ID: $selectedClassId');
            return kelasId == selectedClassId;
          },
          orElse: () => null,
        );

        if (kelas != null) {
          debugPrint('Found kelas: $kelas');
          final String siswaRawJson = kelas['siswa'];
          debugPrint('Siswa raw JSON: $siswaRawJson');

          if (siswaRawJson.isNotEmpty) {
            final List<dynamic> siswaJson = json.decode(siswaRawJson);
            debugPrint('Decoded siswa JSON: $siswaJson');

            setState(() {
              siswaAbsen = siswaJson.map((siswa) {
                return {
                  'name': siswa['nama'],
                  'status': siswa['keterangan'],
                  'time': siswa['jam_absen'],
                  'color': _getStatusColor(siswa['keterangan']),
                };
              }).toList();
              isLoading = false;
            });
          } else {
            debugPrint('No siswa data found.');
            setState(() {
              siswaAbsen = [];
              isLoading = false;
            });
          }
        } else {
          debugPrint('Kelas with ID $selectedClassId not found.');
          setState(() {
            siswaAbsen = [];
            isLoading = false;
          });
        }
      } else {
        debugPrint('Failed to load data: Status Code ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching data: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Gagal mengambil data absensi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'sakit':
        return Colors.blue;
      case 'izin':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final String namaKelas = arguments['namaKelas'] ?? 'Kelas';
    final String waliKelas = arguments['waliKelas'] ?? 'Wali Kelas';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Absensi $namaKelas',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : siswaAbsen.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada data absensi untuk kelas ini.',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(waliKelas),
                      ListView.builder(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: siswaAbsen.length,
                        itemBuilder: (context, index) {
                          final siswa = siswaAbsen[index];
                          return _buildAbsenCard(
                            siswa['name'],
                            'No ${index + 1}', // Penyesuaian nomor dimulai dari data 1
                            siswa['status'],
                            siswa['color'],
                            siswa['time'],
                            namaKelas,
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(String waliKelas) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang',
            style: GoogleFonts.poppins(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            waliKelas,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 8),
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
              Icon(Icons.filter_list, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenCard(String name, String number, String status,
      Color statusColor, String jamAbsen, String kelas) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text(number,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey)),
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
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/detailAbsenAdmin', arguments: {
                      'name': name,
                      'number': number,
                      'kelas': kelas,
                      'keterangan': status,
                      'jamAbsen': jamAbsen,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  child: Text('Lihat Detail',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/editAbsenAdmin', arguments: {
                      'name': name,
                      'number': number,
                      'status': status,
                      'jamAbsen': jamAbsen,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent),
                  child: Text('Edit',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.white)),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/catatanAdmin', arguments: {'name': name});
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Beri Catatan',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
