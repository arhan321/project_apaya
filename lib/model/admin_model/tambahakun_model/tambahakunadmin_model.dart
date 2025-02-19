import 'dart:io';
import 'package:dio/dio.dart' as dio;

class AdminRegisterModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;
  final DateTime birthDate;
  final File? photo;

  AdminRegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.birthDate,
    this.photo,
  });

  /// Konversi objek ke Map untuk dikirim ke API
  Future<Map<String, dynamic>> toJson() async {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'role': role,
      'tanggal_lahir':
          birthDate.toIso8601String().split('T')[0], // Format yyyy-MM-dd
      'photo': photo != null
      // ? await MultipartFile.fromFile(photo!.path,
      // filename: photo!.path.split('/').last)
      // : null,
    };
  }
}
