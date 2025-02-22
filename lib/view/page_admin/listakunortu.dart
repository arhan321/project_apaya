import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
// Pastikan file controller sesuai path jika diperlukan

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      fetchAkunOrtu();
    }
  }

  Future<void> fetchAkunOrtu() async {
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
          akunOrtu = (data as List)
              .where((item) =>
                  item['role']?.toString().toLowerCase() == 'orang_tua')
              .map((item) => {
                    'id': item['id'].toString(),
                    'foto': item['image_url'] ?? '',
                    // Gunakan key 'nama' agar konsisten
                    'nama': item['name'] ?? 'Nama tidak tersedia',
                    'email': item['email'] ?? 'Email tidak tersedia',
                    'password': '********',
                    'role': item['role'] ?? '',
                    // Field tambahan khusus akun orang tua
                    'nomor_telfon': item['nomor_telfon']?.toString() ?? '',
                    'agama': item['agama']?.toString() ?? '',
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

  Future<void> deleteAkunOrtu(String id) async {
    final String url = 'https://absen.randijourney.my.id/api/v1/account/$id';

    try {
      final response = await _dio.delete(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          akunOrtu.removeWhere((akun) => akun['id'] == id);
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

  Widget _buildErrorWidget() {
    return Center(
      child: Text(
        errorMessage,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
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
                  id: akun['id'],
                  foto: akun['foto']!,
                  // Gunakan key 'nama' untuk mendapatkan data nama
                  nama: akun['nama']!,
                  email: akun['email']!,
                  password: akun['password']!,
                  role: akun['role']!,
                  nomorTelfon: akun['nomor_telfon'],
                  agama: akun['agama'],
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
    required String nomorTelfon,
    required String agama,
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
                  Text(
                    'Nomor Telepon: $nomorTelfon',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Agama: $agama',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                // Kirim semua data ke halaman Edit
                Get.toNamed('/editAkunOrtu', arguments: {
                  'id': id,
                  'foto': foto,
                  'name':
                      nama, // Kirim key 'name' agar sesuai dengan yang diharapkan di halaman edit
                  'email': email,
                  'password': password,
                  'role': role,
                  'nomor_telfon': nomorTelfon,
                  'agama': agama,
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Tampilkan modal konfirmasi sebelum menghapus
                Get.defaultDialog(
                  title: "Konfirmasi",
                  middleText: "Apakah Anda yakin ingin menghapus akun ini?",
                  textCancel: "Batal",
                  textConfirm: "Hapus",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    Get.back();
                    deleteAkunOrtu(id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
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
          Get.toNamed('/tambahAkunOrtu');
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
}
