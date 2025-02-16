import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/admin_controller/kelolakelasadmin_controller/editkelas_controller.dart'; // Import Controller

class EditKelasPage extends StatelessWidget {
  // Inisialisasi controller dengan Get.put
  final EditKelasController controller = Get.put(EditKelasController());

  EditKelasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Jika controller.isLoading masih true, tampilkan CircularProgress
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Kelas', style: GoogleFonts.poppins()),
            centerTitle: true,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            'Edit Kelas',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                'Nama Kelas',
                controller.namaKelasController,
              ),
              const SizedBox(height: 20),
              Obx(() {
                // Jika masih loading user
                if (controller.isUserLoading.value) {
                  return const CircularProgressIndicator();
                } else if (controller.users.isEmpty) {
                  return Text(
                    "Tidak ada guru tersedia",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                  );
                } else {
                  // DropdownList Guru
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Pilih Guru',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.blueAccent),
                    ),
                    isExpanded: true,
                    value: controller.selectedUserId.value,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        controller.selectedUserId.value = newValue;
                      }
                    },
                    items: controller.users.map((user) {
                      return DropdownMenuItem<int>(
                        value: user['id'],
                        child: Text(
                          user['name'] ?? 'Nama tidak tersedia',
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    }).toList(),
                  );
                }
              }),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: controller.updateKelas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                  ),
                  child: Text(
                    "Simpan Perubahan",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
