import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../routes/routes.dart';

class NewPasswordScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  // Tambahkan RxBool untuk toggle password
  final RxBool isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 50.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Absenku.',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Silahkan Masukan Sandi Baru Anda',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                  _buildTextField(
                    controller: otpController,
                    hintText: 'Kode OTP',
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: emailController,
                    hintText: 'Email Anda',
                  ),
                  SizedBox(height: 20),
                  // Sandi Baru (dengan toggle)
                  _buildTextField(
                    controller: newPasswordController,
                    hintText: 'Sandi Baru',
                    isPassword: true,
                    isObscureObs: isPasswordVisible,
                  ),
                  SizedBox(height: 30),
                  _buildResetPasswordButton(),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.login),
                      child: Text(
                        'Sudah Memiliki Akun? Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi pembentuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    RxBool? isObscureObs,
  }) {
    // Jika bukan field Password, buat TextField biasa
    if (!isPassword || hintText != 'Sandi Baru') {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ),
      );
    }

    // Jika field ini adalah Password atau Sandi Baru, tambahkan Obx untuk toggle visibilitas.
    return Obx(
      () => Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: !isObscureObs!.value, // negasi karena 'true' = terlihat
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical:
                    15.0), // Tambahkan padding vertikal untuk meratakan teks
            // Suffix icon: tombol toggle
            suffixIcon: IconButton(
              icon: Icon(
                isObscureObs.value ? Icons.visibility : Icons.visibility_off,
                color: Colors.purple,
              ),
              onPressed: () {
                isObscureObs.value = !isObscureObs.value;
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final otp = otpController.text.trim();
          final email = emailController.text.trim();
          final newPassword = newPasswordController.text.trim();

          if (otp.isEmpty || email.isEmpty || newPassword.isEmpty) {
            Get.snackbar(
              'Error',
              'Semua bidang harus diisi',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            return;
          }

          final response = await resetPassword(otp, email, newPassword);

          if (response != null && response['status'] == 200) {
            Get.offAllNamed('/welcome');
          } else {
            Get.snackbar(
              'Info',
              response?['message'] ??
                  'Password berhasil diubah. Anda akan diarahkan ke halaman utama.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromARGB(255, 70, 243, 70),
              colorText: Colors.white,
            );
            Get.offAllNamed('/welcome');
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> resetPassword(
      String otp, String email, String newPassword) async {
    try {
      final url = Uri.parse('https://absen.randijourney.my.id/password/reset');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'code': otp,
          'email': email,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final errorResponse = jsonDecode(response.body);
        return {
          'status': response.statusCode,
          'message': errorResponse['message'] ?? 'Kesalahan tidak diketahui',
        };
      }
    } catch (e) {
      return null;
    }
  }
}
