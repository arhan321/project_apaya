class SiswaAkunModel {
  final String id;
  final String foto;
  final String nama;
  final String email;
  final String password;
  final String role;
  final String noAbsen;

  SiswaAkunModel({
    required this.id,
    required this.foto,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
    required this.noAbsen,
  });

  /// Factory constructor untuk mengonversi JSON ke objek SiswaAkunModel
  factory SiswaAkunModel.fromJson(Map<String, dynamic> json) {
    return SiswaAkunModel(
      id: json['id']?.toString() ?? '',
      foto: json['image_url'] ?? '',
      nama: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      password: '********',
      role: json['role'] ?? '',
      noAbsen: json['nomor_absen']?.toString() ?? 'N/A',
    );
  }
}
