import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class ListAkunOrtu extends StatefulWidget {
  @override
  _ListAkunOrtuState createState() => _ListAkunOrtuState();
}

class _ListAkunOrtuState extends State<ListAkunOrtu> {
  final Dio _dio = Dio();
  List<Map<String, dynamic>> akunOrtu = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAkunOrtu();
  }

  Future<void> fetchAkunOrtu() async {
    const String url = 'https://absen.djncloud.my.id/api/v1/account';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        debugPrint('Data API: $data');

        setState(() {
          akunOrtu = (data as List)
              .where((item) => item['role']?.toLowerCase() == 'orang_tua')
              .map((item) => {
                    'foto': item['image_url'] ?? '',
                    'nama': item['name'] ?? 'Nama tidak tersedia',
                    'email': item['email'] ?? 'Email tidak tersedia',
                    'password': '********', // Jangan tampilkan password asli
                    'role': item['role'] ?? '',
                  })
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
      debugPrint('Kesalahan API: $e');
      setState(() {
        errorMessage = 'Terjadi kesalahan saat memuat data: $e';
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
          onPressed: () => Get.back(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _buildListAkun(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(
              '/tambahAkunOrtu'); // Direct ke halaman Tambah Akun Orang Tua
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

  Widget _buildListAkun() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: akunOrtu.isEmpty
          ? Center(
              child: Text(
                'Tidak ada akun orang tua tersedia.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: akunOrtu.length,
              itemBuilder: (context, index) {
                final akun = akunOrtu[index];
                return _buildAkunCard(
                  context,
                  foto: akun['foto']!,
                  nama: akun['nama']!,
                  email: akun['email']!,
                  password: akun['password']!,
                  role: akun['role']!,
                );
              },
            ),
    );
  }

  Widget _buildAkunCard(
    BuildContext context, {
    required String foto,
    required String nama,
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
              backgroundImage: foto.isNotEmpty
                  ? NetworkImage(foto)
                  : AssetImage('assets/default_profile.png') as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint('Gagal memuat gambar: $exception');
              },
              child: foto.isEmpty
                  ? Text(
                      'No Image',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      textAlign: TextAlign.center,
                    )
                  : null,
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
                  'email': email,
                  'password': password,
                  'role': role,
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text(
        errorMessage,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
      ),
    );
  }
}
