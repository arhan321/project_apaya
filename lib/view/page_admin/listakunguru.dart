import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class ListAkunGuru extends StatefulWidget {
  @override
  _ListAkunGuruState createState() => _ListAkunGuruState();
}

class _ListAkunGuruState extends State<ListAkunGuru> {
  final Dio _dio = Dio();
  List<Map<String, dynamic>> akunGuru = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAkunGuru();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      fetchAkunGuru();
    }
  }

  Future<void> fetchAkunGuru() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    const String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      final response = await _dio.get(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        setState(() {
          akunGuru = (data as List)
              .where((item) => item['role']?.toString().toLowerCase() == 'guru')
              .map((item) => {
                    'id': item['id']?.toString() ?? '',
                    'foto': item['image_url'] ?? '',
                    'nama': item['name']?.toString() ?? 'Nama tidak tersedia',
                    'email':
                        item['email']?.toString() ?? 'Email tidak tersedia',
                    'password': '********',
                    'role': item['role']?.toString() ?? '',
                    // Field tambahan
                    'nip_guru': item['nip_guru']?.toString() ?? '',
                    'wali_kelas': item['wali_kelas']?.toString() ?? '',
                    'umur': item['umur']?.toString() ?? '',
                    'nomor_telfon': item['nomor_telfon']?.toString() ?? '',
                    // Tanggal lahir
                    'tanggal_lahir': item['tanggal_lahir']?.toString() ?? '',
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
      setState(() {
        errorMessage = 'Terjadi kesalahan saat memuat data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteAkunGuru(String id) async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account/$id';

    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          akunGuru.removeWhere((akun) => akun['id'] == id);
        });
        Get.snackbar(
          'Berhasil',
          'Akun berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal menghapus akun',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus akun',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
          'Daftar Akun Guru',
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
              ? Center(
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                  ),
                )
              : _buildListAkun(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/tambahAkunGuru');
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
      child: akunGuru.isEmpty
          ? Center(
              child: Text(
                'Tidak ada akun guru tersedia.',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: akunGuru.length,
              itemBuilder: (context, index) {
                final akun = akunGuru[index];
                return _buildAkunCard(
                  context,
                  id: akun['id'],
                  foto: akun['foto'],
                  nama: akun['nama'],
                  email: akun['email'],
                  password: akun['password'],
                  role: akun['role'],
                  // Field tambahan
                  nipGuru: akun['nip_guru'],
                  waliKelas: akun['wali_kelas'],
                  umur: akun['umur'],
                  nomorTelfon: akun['nomor_telfon'],
                  tanggalLahir: akun['tanggal_lahir'],
                );
              },
            ),
    );
  }

  Widget _buildAkunCard(
    BuildContext context, {
    required String id,
    required String foto,
    required String nama,
    required String email,
    required String password,
    required String role,
    // Field tambahan
    required String nipGuru,
    required String waliKelas,
    required String umur,
    required String nomorTelfon,
    required String tanggalLahir,
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
                // Kirim semua data ke halaman Edit
                Get.toNamed('/editAkunGuru', arguments: {
                  'id': id,
                  'foto': foto,
                  'nama': nama,
                  'email': email,
                  'password': password,
                  'role': role,
                  // Field tambahan
                  'nip_guru': nipGuru,
                  'wali_kelas': waliKelas,
                  'tanggal_lahir': tanggalLahir,
                  'umur': umur,
                  'nomor_telfon': nomorTelfon,
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteAkunGuru(id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
