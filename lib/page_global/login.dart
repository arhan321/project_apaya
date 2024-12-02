import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Tangkap role dari Get.arguments
    final role = Get.arguments?['role'] ?? 'siswa'; // Default ke 'siswa' jika tidak ada role

    usernameFocus.addListener(() {
      if (usernameFocus.hasFocus) {
        FocusScope.of(context).requestFocus(usernameFocus);
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Gradient
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
          // Konten Halaman
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 30.0,
                right: 30.0,
                top: 50.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Get.toNamed(AppRoutes.welcome);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 50),
                  _buildTextField(
                    controller: usernameController,
                    focusNode: usernameFocus,
                    icon: Icons.person,
                    hint: 'Username',
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    icon: Icons.lock,
                    hint: 'Password',
                    isPassword: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.forgotPassword);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildLoginButton(context, role),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Kirim role ke halaman RegisterScreen
                      Get.toNamed(AppRoutes.register, arguments: {'role': role});
                    },
                    child: Text(
                      'Don\'t have an account? Register here',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
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
        focusNode: focusNode,
        obscureText: isPassword,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, String role) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Arahkan ke halaman sesuai dengan role
          if (role == 'guru') {
            Get.toNamed(AppRoutes.mainPageGuru);
          } else if (role == 'siswa') {
            Get.toNamed(AppRoutes.mainPage);
          } else if (role == 'orangtua') {
            Get.toNamed(AppRoutes.mainPageOrtu);
          } else {
            // Role admin dinonaktifkan sementara
            Get.snackbar(
              'Info',
              'Halaman untuk role $role belum tersedia.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orangeAccent,
              colorText: Colors.white,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
