import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/routes.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Error', 'Email dan Password tidak boleh kosong!');
      return;
    }

    try {
      isLoading(true);

      final response = await _dio.post(
        'https://absen.randijourney.my.id/api/v1/account/login',
        data: {'email': email, 'password': password},
        options: Options(
          headers: {'Accept': 'application/json'},
          responseType: ResponseType.json,
        ),
      );

      // Debugging untuk memastikan respons API
      debugPrint('Response Data: ${response.data}');
      debugPrint('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Pastikan respons JSON terurai dengan benar
        final data = Map<String, dynamic>.from(response.data);
        final token = data['token']; // Ambil token dari respons
        final user = data['user'] != null
            ? Map<String, dynamic>.from(data['user'])
            : <String, dynamic>{};
        final role = user['role'];

        debugPrint('Token: $token');
        debugPrint('User Data: $user');

        if (token != null && role != null) {
          await _saveSession(user, role, token); // Simpan token dan sesi
          _showSnackbar('Success', 'Login berhasil!');
          _protectAndNavigate(role); // Navigasi berdasarkan role
        } else {
          _showSnackbar(
              'Error', 'Token atau role tidak ditemukan dalam respons.');
        }
      } else {
        _showSnackbar('Error', response.data['message'] ?? 'Login gagal!');
      }
    } on DioException catch (e) {
      // Tangkap kesalahan jaringan
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan jaringan';
      _showSnackbar('Error', errorMessage);
    } catch (e) {
      _showSnackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveSession(
      Map<String, dynamic> user, String role, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('userName', user['name']);
    await prefs.setString('userEmail', user['email']);
    await prefs.setString('userRole', role);
    await prefs.setString(
        'authToken', token); // Simpan token ke SharedPreferences
    debugPrint('Token tersimpan: $token');
  }

  void _protectAndNavigate(String role) {
    switch (role) {
      case 'guru':
        Get.offAllNamed(AppRoutes.mainPageGuru);
        break;
      case 'siswa':
        Get.offAllNamed(AppRoutes.mainPage);
        break;
      case 'orang_tua':
        Get.offAllNamed(AppRoutes.mainPageOrtu);
        break;
      case 'admin':
        Get.offAllNamed(AppRoutes.adminDashboard);
        break;
      default:
        _showSnackbar('Error', 'Role tidak dikenali! Akses ditolak.');
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data termasuk token

    _showSnackbar('Success', 'Logout berhasil!');
    Get.offAllNamed(AppRoutes.login);
  }

  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: title == 'Error' ? Colors.redAccent : Colors.greenAccent,
      colorText: Colors.white,
    );
  }
}
