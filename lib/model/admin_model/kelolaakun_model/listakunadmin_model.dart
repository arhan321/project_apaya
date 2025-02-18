class AdminAkunModel {
  final String id;
  final String foto;
  final String username;
  final String email;
  final String password;
  final String role;

  AdminAkunModel({
    required this.id,
    required this.foto,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  /// Factory constructor untuk parsing dari JSON ke objek AdminAkunModel
  factory AdminAkunModel.fromJson(Map<String, dynamic> json) {
    return AdminAkunModel(
      id: json['id']?.toString() ?? '',
      foto: json['image_url'] ?? '',
      username: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      password: json['password'] ?? '********',
      role: json['role'] ?? '',
    );
  }
}
