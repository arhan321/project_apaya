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
  File? _imageFile;
  final picker = ImagePicker();
  String errorMessage = '';
  String? userId;

  final dio.Dio _dio = dio.Dio();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data from the server
  Future<void> _loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      userId = prefs.getString('userId'); // Get the user ID

      if (authToken == null || userId == null) {
        Get.offAllNamed(
            '/login'); // If token or userId is not present, redirect to login
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
          // If image_url exists, set it properly
          if (data['image_url'] != null && data['image_url'].isNotEmpty) {
            _imageFile = null; // No need to use File for URL images
          } else {
            _imageFile = null; // No photo available
          }
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

  // Pick image from gallery
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

  // Update profile data
  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (authToken == null || userId == null) {
      Get.offAllNamed('/login');
      return;
    }

    final String url =
        'https://absen.djncloud.my.id/api/v1/account/update/$userId'; // Pass the user ID in the URL
    final formData = dio.FormData.fromMap({
      'name': nameController.text,
      'nomor_absen': numberController.text,
      'photo': _imageFile != null
          ? await dio.MultipartFile.fromFile(_imageFile!.path)
          : null,
    });

    try {
      final response = await _dio.put(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        Get.offAllNamed('/profile'); // Redirect to profile page
      } else {
        Get.snackbar('Error', 'Update failed. Please try again.');
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
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
              ),
              child: Text("Simpan Perubahan",
                  style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(String label, TextEditingController controller,
      {bool isEnabled = true}) {
    return TextField(
      controller: controller,
      enabled: isEnabled, // To disable the "Kelas" field
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
