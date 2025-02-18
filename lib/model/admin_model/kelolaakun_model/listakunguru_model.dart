class GuruAkunModel {
  final String id;
  final String foto;
  final String nama;
  final String email;
  final String password;
  final String role;

  GuruAkunModel({
    required this.id,
    required this.foto,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
  });

  /// Factory constructor untuk parsing dari JSON ke objek GuruAkunModel
  factory GuruAkunModel.fromJson(Map<String, dynamic> json) {
    return GuruAkunModel(
      id: json['id']?.toString() ?? '',
      foto: json['image_url'] ?? '',
      nama: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      password: '********',
      role: json['role'] ?? '',
    );
  }
}
