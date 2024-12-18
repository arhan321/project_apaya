import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../model/routes/routes.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan Password tidak boleh kosong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse('https://absen.djncloud.my.id/api/v1/account/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final role = data['user']?['role']; // Ambil role dari respons

        if (role != null) {
          Get.snackbar(
            'Success',
            'Login Berhasil!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent,
            colorText: Colors.white,
          );
          _protectAndNavigate(role); // Validasi role dan navigasi
        } else {
          Get.snackbar(
            'Error',
            'Role tidak ditemukan dalam respons.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Jika respons server menyatakan kredensial tidak valid
        Get.snackbar(
          'Error',
          'Email atau password salah!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        final error = json.decode(response.body);
        final errorMessage = error['message'] ?? 'Login gagal!';
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
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
        Get.snackbar(
          'Error',
          'Role tidak dikenali! Akses ditolak.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
    }
  }
}
