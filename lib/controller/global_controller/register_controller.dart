import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../routes/routes.dart';
import 'package:flutter/material.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final roleController = TextEditingController();
  final nomorAbsenController = TextEditingController();
  final isLoading = false.obs;

  // Tambahkan selectedRole sebagai properti reaktif
  var selectedRole = ''.obs;

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final role = selectedRole.value; // Gunakan selectedRole untuk role

    if (name.isEmpty || email.isEmpty || password.isEmpty || role.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua kolom wajib diisi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Password dan Konfirmasi Password tidak cocok!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final validRoles = [
      'admin',
      'siswa',
      'guru',
      'orang_tua',
      'kepala_sekolah'
    ];
    if (!validRoles.contains(role)) {
      Get.snackbar(
        'Error',
        'Role tidak valid! Pilih role yang sesuai.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (role == 'siswa') {
      _showNomorAbsenForm(name, email, password, confirmPassword, role);
      return;
    }

    _submitRegistration(name, email, password, confirmPassword, role);
  }

  void _showNomorAbsenForm(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Isi Nomor Absen',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nomorAbsenController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nomor Absen',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final nomorAbsen = nomorAbsenController.text.trim();
                if (nomorAbsen.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Nomor Absen tidak boleh kosong!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return;
                }
                Get.back();
                _submitRegistration(
                    name, email, password, confirmPassword, role,
                    nomorAbsen: nomorAbsen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _submitRegistration(
    String name,
    String email,
    String password,
    String confirmPassword,
    String role, {
    String? nomorAbsen,
  }) async {
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse('https://absen.djncloud.my.id/api/v1/account/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'role': role,
          if (role == 'siswa') 'nomor_absen': nomorAbsen,
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        Get.snackbar(
          'Success',
          'Registrasi Berhasil! ${data['message'] ?? ''}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutes.login);
      } else {
        final error = json.decode(response.body);
        final errorMessage = error['message'] ?? 'Registrasi gagal!';
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
}
