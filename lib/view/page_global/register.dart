import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/global_controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());
  final List<String> roleOptions = ['admin', 'guru', 'siswa', 'orang_tua'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  _buildTextField(
                      controller.nameController, Icons.person, 'Nama Lengkap'),
                  const SizedBox(height: 20),
                  _buildTextField(
                      controller.emailController, Icons.email, 'Email'),
                  const SizedBox(height: 20),
                  _buildTextField(
                      controller.passwordController, Icons.lock, 'Password',
                      isPassword: true),
                  const SizedBox(height: 20),
                  _buildTextField(controller.confirmPasswordController,
                      Icons.lock_outline, 'Konfirmasi Password',
                      isPassword: true),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    label: 'Role',
                    options: roleOptions,
                    value: controller.selectedRole.value,
                    onChanged: (value) {
                      controller.selectedRole.value = value!;
                      controller.roleController.text = value;
                    },
                  ),
                  if (controller.selectedRole.value == 'siswa') ...[
                    const SizedBox(height: 20),
                    _buildTextField(controller.nomorAbsenController,
                        Icons.format_list_numbered, 'Nomor Absen'),
                  ],
                  const SizedBox(height: 30),
                  Obx(() => _buildRegisterButton(controller.isLoading.value)),
                ],
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
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
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
