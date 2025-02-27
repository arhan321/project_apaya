import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/global_controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final List<String> roleOptions = ['admin', 'guru', 'siswa', 'orang_tua'];

  // Tambahkan RxBool untuk toggle password dan konfirmasi password
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Form
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tombol back
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back(); // Kembali ke halaman sebelumnya
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Judul
                  Center(
                    child: Text(
                      'Daftar Akun Baru',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Isi formulir di bawah ini untuk mendaftar!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nama Lengkap
                  _buildTextField(
                    controller.nameController,
                    Icons.person,
                    'Nama Lengkap',
                  ),
                  const SizedBox(height: 20),
                  // Email
                  _buildTextField(
                    controller.emailController,
                    Icons.email,
                    'Email',
                  ),
                  const SizedBox(height: 20),
                  // Password (dengan toggle)
                  _buildTextField(
                    controller.passwordController,
                    Icons.lock,
                    'Password',
                    isPassword: true,
                    isObscureObs: isPasswordVisible,
                  ),
                  const SizedBox(height: 20),
                  // Konfirmasi Password (dengan toggle)
                  _buildTextField(
                    controller.confirmPasswordController,
                    Icons.lock_outline,
                    'Konfirmasi Password',
                    isPassword: true,
                    isObscureObs: isConfirmPasswordVisible,
                  ),
                  const SizedBox(height: 20),
                  // Dropdown Role
                  _buildDropdownField(
                    label: 'Role',
                    options: roleOptions,
                    value: controller.selectedRole.value,
                    onChanged: (value) {
                      controller.selectedRole.value = value!;
                      controller.roleController.text = value;
                    },
                  ),
                  // Jika role = 'siswa'
                  if (controller.selectedRole.value == 'siswa') ...[
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller.nomorAbsenController,
                      Icons.format_list_numbered,
                      'Nomor Absen',
                    ),
                  ],
                  const SizedBox(height: 30),
                  // Tombol Daftar
                  Obx(() => _buildRegisterButton(controller.isLoading.value)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi pembentuk TextField
  Widget _buildTextField(
      TextEditingController textController, IconData icon, String hint,
      {bool isPassword = false, RxBool? isObscureObs}) {
    // Jika bukan field Password, buat TextField biasa
    if (!isPassword || hint != 'Password' && hint != 'Konfirmasi Password') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: textController,
          obscureText: isPassword, // untuk 'Konfirmasi Password' masih biasa
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.purple),
            hintText: hint,
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      );
    }

    // Jika field ini adalah Password atau Konfirmasi Password,
    // tambahkan Obx untuk toggle visibilitas.
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: textController,
          obscureText: !isObscureObs!.value, // negasi karena 'true' = terlihat
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.purple),
            hintText: hint,
            border: InputBorder.none,
            hintStyle: GoogleFonts.poppins(),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
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

  /// Dropdown untuk Role
  Widget _buildDropdownField({
    required String label,
    required List<String> options,
    required String value,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        onChanged: onChanged,
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(
                  option,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            )
            .toList(),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.purple),
      ),
    );
  }

  /// Tombol Register
  Widget _buildRegisterButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => controller.register(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.purpleAccent)
            : Text(
                'Daftar',
                style: GoogleFonts.poppins(
                  color: Colors.purpleAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
