// File: lib/model/admin_model/admin_akun_model.dart

class AdminAkunModel {
  final String id;
  final String foto; // Properti foto ditambahkan
  final String name;
  final String email;
  final String password;
  final String? tanggalLahir; // Opsional

  AdminAkunModel({
    required this.id,
    required this.foto,
    required this.name,
    required this.email,
    required this.password,
    this.tanggalLahir,
  });

  /// Factory constructor untuk mengonversi JSON (atau Map) ke objek AdminAkunModel
  factory AdminAkunModel.fromJson(Map<String, dynamic> json) {
    return AdminAkunModel(
      id: json['id']?.toString() ?? '',
      foto: json['image_url'] ?? '', // Mengambil foto dari key image_url
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      tanggalLahir: json['tanggal_lahir'],
    );
  }

  @override
  String toString() {
    return 'AdminAkunModel(id: $id, foto: $foto, name: $name, email: $email, tanggalLahir: $tanggalLahir)';
  }
}
