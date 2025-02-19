class AdminModel {
  final String name;
  final String role;
  final String photoUrl;
  final String birthDate;

  AdminModel({
    required this.name,
    required this.role,
    required this.photoUrl,
    required this.birthDate,
  });

  // Factory method untuk membuat objek dari JSON
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      name: json['name'] ?? 'Nama tidak tersedia',
      role: 'Administrator', // Tetap default sebagai Administrator
      photoUrl: json['image_url'] ?? '',
      birthDate: json['tanggal_lahir'] ?? 'Tanggal lahir tidak tersedia',
    );
  }
}
