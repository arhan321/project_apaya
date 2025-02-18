class OrtuAkunModel {
  final String id;
  final String foto;
  final String nama;
  final String email;
  final String password;
  final String role;

  OrtuAkunModel({
    required this.id,
    required this.foto,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
  });

  /// Factory constructor untuk mengonversi JSON ke objek OrtuAkunModel
  factory OrtuAkunModel.fromJson(Map<String, dynamic> json) {
    return OrtuAkunModel(
      id: json['id']?.toString() ?? '',
      foto: json['image_url'] ?? '',
      nama: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      password: '********',
      role: json['role'] ?? '',
    );
  }
}
