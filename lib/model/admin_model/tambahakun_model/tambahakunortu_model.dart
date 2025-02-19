import 'dart:io';
import 'package:dio/dio.dart' as dio;

class OrtuModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final File? photo;

  OrtuModel({
    required this.name,
    required this.email,
    required this.password,
    this.role = 'orang_tua',
    this.photo,
  });

  /// Konversi model ke `FormData` untuk dikirim ke API
  Future<dio.FormData> toFormData() async {
    return dio.FormData.fromMap({
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirmation': password,
      'role': role,
      'photo': photo != null
          ? await dio.MultipartFile.fromFile(
              photo!.path,
              filename: photo!.path.split('/').last,
            )
          : null,
    });
  }
}
