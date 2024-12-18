import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/routes/routes.dart';

class NewPasswordScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  final FocusNode usernameFocusNode = FocusNode(); // Tambahkan FocusNode
  final FocusNode passwordFocusNode = FocusNode(); // Tambahkan FocusNode

  @override
  Widget build(BuildContext context) {
    // Listener pada FocusNode untuk debugging
    usernameFocusNode.addListener(() {
      if (usernameFocusNode.hasFocus) {
        print('Username field got focus');
      }
    });

    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        print('Password field got focus');
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Menyesuaikan layout saat keyboard muncul
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
                bottom:
                    MediaQuery.of(context).viewInsets.bottom, // Padding dinamis
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
                    context: context,
                    controller: usernameController,
                    focusNode: usernameFocusNode,
                    hintText: 'Nama',
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    context: context,
                    controller: newPasswordController,
                    focusNode: passwordFocusNode,
                    hintText: 'Sandi Baru',
                    isPassword: true,
                  ),
                  SizedBox(height: 30),
                  _buildChangePasswordButton(),
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

  Widget _buildTextField({
    required BuildContext context, // Tambahkan BuildContext
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    bool isPassword = false,
  }) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode); // Paksa fokus
      },
      child: Container(
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
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String username = usernameController.text.trim();
          String newPassword = newPasswordController.text.trim();
          if (username.isEmpty || newPassword.isEmpty) {
            Get.snackbar(
              'Error',
              'Nama dan sandi baru harus diisi',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              'Success',
              'Sandi berhasil diubah',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.greenAccent,
              colorText: Colors.white,
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
          'Ubah Sandi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
