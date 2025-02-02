import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../routes/routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController usernameController = TextEditingController();
  bool showResetPasswordButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Absenku.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    'Masukan Email Anda untuk mendapatkan link reset password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Center(
                  child: _buildTextField(
                      usernameController, 'Masukkan Email Anda')),
              SizedBox(height: 20),
              _buildForgotPasswordButton(),
              if (showResetPasswordButton) ...[
                SizedBox(height: 20),
                _buildResetPasswordButton(),
              ],
              Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.register),
                  child: Text(
                    'Belum Memiliki Akun? Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      height: 50,
      width: double.infinity,
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
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final email = usernameController.text.trim();
          if (email.isEmpty) {
            Get.snackbar('Error', 'Email tidak boleh kosong');
            return;
          }

          Get.dialog(
            Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );

          final response = await sendResetPasswordEmail(email);

          Get.back();

          if (response != null && response['status'] == 200) {
            Get.snackbar('Success', 'kode OTP telah dikirim ke email anda');
            setState(() {
              showResetPasswordButton = true;
            });
          } else {
            Get.snackbar(
              'Error',
              response?['message'] ?? 'Terjadi kesalahan, coba lagi nanti.',
            );
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
          'Forgot Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/new-password');
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.green,
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

  Future<Map<String, dynamic>?> sendResetPasswordEmail(String email) async {
    try {
      final url = Uri.parse('https://absen.randijourney.my.id/password/email');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        Get.snackbar(
          'Error',
          'Kesalahan dari sisi klien: ${response.statusCode}',
        );
        return jsonDecode(response.body);
      } else if (response.statusCode >= 500) {
        Get.snackbar(
          'Error',
          'Kesalahan dari sisi server: ${response.statusCode}',
        );
        return jsonDecode(response.body);
      } else {
        Get.snackbar(
          'Error',
          'Kesalahan tidak diketahui. Status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        'Unexpected Error',
        'Kesalahan tak terduga: ${e.toString()}',
      );
      return null;
    }
  }
}
