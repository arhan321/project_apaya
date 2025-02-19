import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';

class GuruModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final DateTime tanggalLahir;
  final File? photo;

  GuruModel({
    required this.name,
    required this.email,
    required this.password,
    required this.tanggalLahir,
    this.role = 'guru',
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
      'tanggal_lahir': DateFormat('yyyy-MM-dd').format(tanggalLahir),
      'photo': photo != null
          ? await dio.MultipartFile.fromFile(
              photo!.path,
              filename: photo!.path.split('/').last,
            )
          : null,
    });
  }
}
