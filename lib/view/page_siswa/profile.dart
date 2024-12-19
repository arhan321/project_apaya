import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String studentName = '';
  String studentClass = 'Kelas 6A'; // Informasi kelas dibuat statis
  String studentNumber = '';
  String? photoUrl;
  bool isLoading = true;
  String errorMessage = '';

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    const String url = 'https://absen.djncloud.my.id/auth/me';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        setState(() {
          errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
          isLoading = false;
        });
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        debugPrint('Data berhasil diambil: $data');

        setState(() {
          studentName = data['name'] ?? 'Nama tidak tersedia';
          studentNumber = data['nomor_absen']?.toString() ?? 'N/A';
          photoUrl = data['image_url'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Gagal mengambil data. Status Code: ${response.statusCode}\nPesan: ${response.data}';
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Kesalahan: $e');
      setState(() {
        errorMessage = 'Terjadi kesalahan saat memuat data.';
        isLoading = false;
      });
    }
  }

  void editProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    debugPrint("Auth token: $authToken");

    if (authToken == null) {
      debugPrint("Token is null, redirecting to login");
      Get.offAllNamed('/login');
      return;
    }

    try {
      debugPrint("Navigating to EditProfileSiswaPage");
      Get.toNamed('/editProfileSiswa');
    } catch (e) {
      debugPrint("Error during navigation to edit profile: $e");
      Get.snackbar('Error', 'Unable to navigate to Edit Profile');
    }
  }

  // void deleteAccount() async {
  //   const String url = 'https://absen.djncloud.my.id/api/v1/account/logout';

  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final authToken = prefs.getString('authToken');

  //     if (authToken == null) {
  //       Get.offAllNamed('/login');
  //       return;
  //     }

  //     final response = await _dio.delete(
  //       url,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $authToken',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       Get.snackbar('Success', 'Akun berhasil dihapus');
  //       prefs.clear();
  //       Get.offAllNamed('/login');
  //     } else {
  //       Get.snackbar('Error', 'Gagal menghapus akun');
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Terjadi kesalahan saat menghapus akun');
  //     debugPrint('Kesalahan saat menghapus akun: $e');
  //   }
  // }

// ini adalah untuk session logout
  void logout() async {
    const String url = 'https://absen.djncloud.my.id/auth/logout';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        // Token tidak ditemukan, arahkan ke login tanpa menampilkan error
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken', // Kirim token Bearer
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Logout berhasil, hapus token dan data sesi tanpa feedback
        prefs.remove('authToken'); // Hapus token
        prefs.remove('userName'); // Hapus nama pengguna
        prefs.remove('userEmail'); // Hapus email pengguna

        // Redirect ke halaman login tanpa menampilkan feedback apapun
        Get.offAllNamed('/login');
      } else {
        // Logout gagal, langsung redirect ke halaman login
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Jika terjadi kesalahan saat logout, langsung redirect ke halaman login
      Get.offAllNamed('/login');
      debugPrint('Error during logout: $e');
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
          'Profil Siswa',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Profile Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            photoUrl != null && photoUrl!.isNotEmpty
                                ? NetworkImage(photoUrl!) // URL gambar profil
                                : AssetImage('assets/placeholder.jpg')
                                    as ImageProvider, // Placeholder
                      ),
                      SizedBox(height: 16),
                      Text(
                        studentName,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kelas: $studentClass',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No Absen: $studentNumber',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Edit Profile Button
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Edit Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 12),
              // Delete Account Button
              // ElevatedButton(
              //   onPressed: () {
              //     Get.defaultDialog(
              //       title: "Hapus Akun",
              //       middleText: "Apakah Anda yakin ingin menghapus akun ini?",
              //       confirm: ElevatedButton(
              //         onPressed: deleteAccount,
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.redAccent,
              //         ),
              //         child: Text("Hapus",
              //             style: GoogleFonts.poppins(color: Colors.white)),
              //       ),
              //       cancel: TextButton(
              //         onPressed: () => Get.back(),
              //         child: Text("Batal",
              //             style: GoogleFonts.poppins(color: Colors.blueAccent)),
              //       ),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.redAccent,
              //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              //   child: Text(
              //     'Hapus Akun',
              //     style: GoogleFonts.poppins(
              //       color: Colors.white,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              SizedBox(height: 12),
              // Logout Button
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 80, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Terjadi Kesalahan!',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                'Coba Lagi',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
