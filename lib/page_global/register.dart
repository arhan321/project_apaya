import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db_helper.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noAbsenController = TextEditingController(); // Untuk siswa

  void register(BuildContext context, String role) async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String name = nameController.text;
    String noAbsen = noAbsenController.text;

    if (username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        name.isNotEmpty &&
        (role == 'guru' || (role == 'siswa' && noAbsen.isNotEmpty))) {
      if (password == confirmPassword) {
        var conn = await DBHelper.getConnection();
        var result = await conn.query(
          'INSERT INTO users (username, email, password, name, no_absen, role) VALUES (?, ?, ?, ?, ?, ?)',
          [
            username,
            email,
            password,
            name,
            role == 'siswa' ? noAbsen : null, // Isi noAbsen hanya untuk siswa
            role
          ],
        );
        await conn.close();

        if (result.affectedRows! > 0) {
          Get.snackbar(
            'Success',
            'Account created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent,
            colorText: Colors.white,
          );
          Get.off(() => LoginScreen());
        } else {
          Get.snackbar(
            'Error',
            'Failed to create account',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = Get.arguments?['role'] ?? 'siswa'; // Default ke siswa jika tidak ada role

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.off(() => LoginScreen()),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      role == 'siswa' ? 'Register as Student' : 'Register as Teacher',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign up to get started!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 40),
                    _buildTextField(nameController, Icons.person, 'Full Name'),
                    SizedBox(height: 20),
                    _buildTextField(usernameController, Icons.person_outline, 'Username'),
                    SizedBox(height: 20),
                    _buildTextField(emailController, Icons.email, 'Email'),
                    SizedBox(height: 20),
                    _buildTextField(passwordController, Icons.lock, 'Password', isPassword: true),
                    SizedBox(height: 20),
                    _buildTextField(confirmPasswordController, Icons.lock_outline, 'Confirm Password', isPassword: true),
                    if (role == 'siswa') ...[
                      // Tampilkan form nomor absen hanya untuk siswa
                      SizedBox(height: 20),
                      _buildTextField(noAbsenController, Icons.format_list_numbered, 'Nomor Absen'),
                    ],
                    SizedBox(height: 40),
                    _buildRegisterButton(context, role),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Get.off(() => LoginScreen()),
                      child: Text(
                        'Already have an account? Login here',
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hint,
      {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.purple),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18.0),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, String role) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => register(context, role),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Register',
          style: TextStyle(
            color: Colors.purpleAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
