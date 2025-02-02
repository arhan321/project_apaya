import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controller/guru_controller/editprofileguru_controller.dart';

class EditProfileGuruPage extends StatelessWidget {
  final controller = Get.put(EditProfileGuruController());

  final List<String> agamaList = [
    'islam',
    'kristen',
    'katolik',
    'hindu',
    'budha',
    'konghucu',
  ]; // Daftar nilai enum untuk dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Edit Profile Guru',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: GetBuilder<EditProfileGuruController>(
        initState: (_) async {
          // Fetch wali_kelas data saat halaman dimulai
          await controller.fetchWaliKelasData();
        },
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _.imageFile != null
                            ? FileImage(_.imageFile!)
                            : (_.imageUrl != null
                                ? NetworkImage(_.imageUrl!)
                                : null),
                        child: _.imageFile == null && _.imageUrl == null
                            ? Text(
                                'Foto Kosong',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _.pickImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 20,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                _buildInputField('Nama Guru', _.nameController),
                SizedBox(height: 20),
                _buildInputField('NIP Guru', _.nipGuruController),
                SizedBox(height: 20),
                _buildDropdownField(
                  'Agama',
                  agamaList,
                  _.agamaController.text,
                  (value) {
                    _.agamaController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                _buildInputField('Umur', _.umurController),
                SizedBox(height: 20),
                _buildDropdownField(
                  'Wali Kelas',
                  _.waliKelasList,
                  _.waliKelasController.text,
                  (value) {
                    _.waliKelasController.text = value!;
                  },
                ),
                SizedBox(height: 20),
                _buildInputField('Role', _.roleController, isEnabled: false),
                SizedBox(height: 20),
                _buildDateField(
                    context, 'Tanggal Lahir', _.birthDateController),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  ),
                  child: Text(
                    "Simpan Perubahan",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _.uploadPhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  ),
                  child: Text(
                    "Upload Foto",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isEnabled = true}) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
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

  Widget _buildDropdownField(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    // Memastikan bahwa nilai yang dipilih ada dalam daftar items
    if (value != null && !items.contains(value)) {
      value = null; // Set value ke null jika tidak ada dalam daftar
    }

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: GoogleFonts.poppins()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          controller.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
