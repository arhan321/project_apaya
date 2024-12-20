import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileSiswaPage extends StatefulWidget {
  @override
  _EditProfileSiswaPageState createState() => _EditProfileSiswaPageState();
}

class _EditProfileSiswaPageState extends State<EditProfileSiswaPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController =
      TextEditingController(text: 'Kelas 6A');
  final TextEditingController numberController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();
  String errorMessage = '';
  String? userId;
  String? authToken;

  final dio.Dio _dio = dio.Dio();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('authToken');

      if (authToken == null) {
        Get.snackbar('Session Expired', 'Please log in again.',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.get(
        'https://absen.djncloud.my.id/auth/me',
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          nameController.text = data['name'] ?? '';
          numberController.text = data['nomor_absen']?.toString() ?? '';
          userIdController.text = data['id']?.toString() ?? '';
          userId = data['id']?.toString();
          _imageFile = null;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch profile data. Please try again later.';
        });
        debugPrint('Error loading profile: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred while loading profile data';
      });
      debugPrint('Error during profile load: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> _updateProfile() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url = 'https://absen.djncloud.my.id/api/v1/account/$userId';

    try {
      // Siapkan data JSON
      Map<String, dynamic> data = {
        if (nameController.text.isNotEmpty) 'name': nameController.text,
        if (numberController.text.isNotEmpty)
          'nomor_absen': numberController.text,
      };

      // Kirim request PUT untuk data lainnya
      final response = await _dio.put(
        url,
        data: data, // Kirim sebagai JSON
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully.');
        await _loadProfileData();
      } else {
        Get.snackbar('Error', 'Failed to update profile.');
        debugPrint('Error updating profile: ${response.statusCode}');
      }
    } catch (e) {
      String errorMessage = 'An error occurred while updating your profile.';
      if (e is dio.DioException) {
        if (e.response != null) {
          errorMessage = 'Server Error: ${e.response?.data}';
          debugPrint('Dio Error Response: ${e.response?.data}');
        } else {
          errorMessage = 'Network Error: ${e.message}';
          debugPrint('Dio Network Error: ${e.message}');
        }
      } else {
        errorMessage = 'Unknown Error: ${e.toString()}';
        debugPrint('Unknown Error: $e');
      }

      Get.snackbar('Error', errorMessage);
    }
  }

  Future<void> _uploadPhoto() async {
    if (authToken == null || userId == null) {
      Get.snackbar('Error',
          'Session expired or missing information. Please log in again.');
      return;
    }

    final String url =
        'https://absen.djncloud.my.id/api/v1/account/$userId/foto';

    try {
      if (_imageFile != null) {
        String fileName = _imageFile!.path.split('/').last;

        dio.FormData formData = dio.FormData.fromMap({
          'photo': await dio.MultipartFile.fromFile(
            _imageFile!.path,
            filename: fileName,
          ),
        });

        final response = await _dio.post(
          // Menggunakan POST
          url,
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $authToken',
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Photo uploaded successfully.');
          await _loadProfileData(); // Reload data setelah upload berhasil
        } else {
          Get.snackbar('Error', 'Failed to upload photo.');
          debugPrint('Error uploading photo: ${response.statusCode}');
        }
      } else {
        Get.snackbar('Error', 'No photo selected.');
      }
    } catch (e) {
      String errorMessage = 'An error occurred while uploading photo.';
      if (e is dio.DioException) {
        if (e.response != null) {
          errorMessage = 'Server Error: ${e.response?.data}';
          debugPrint('Dio Error Response: ${e.response?.data}');
        } else {
          errorMessage = 'Network Error: ${e.message}';
          debugPrint('Dio Network Error: ${e.message}');
        }
      } else {
        errorMessage = 'Unknown Error: ${e.toString()}';
        debugPrint('Unknown Error: $e');
      }

      Get.snackbar('Error', errorMessage);
    }
  }

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
          'Edit Profile Siswa',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  _imageFile != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(_imageFile!),
                        )
                      : Container(
                          height: 120,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Text(
                            'Foto Kosong',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
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
            _buildInputField('Nama Siswa', nameController),
            SizedBox(height: 20),
            _buildInputField('Kelas', classController, isEnabled: false),
            SizedBox(height: 20),
            _buildInputField('Nomor Absen', numberController),
            SizedBox(height: 20),
            _buildInputField('User ID', userIdController, isEnabled: false),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: Text("Simpan Perubahan",
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadPhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: Text("Upload Foto",
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
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
}
