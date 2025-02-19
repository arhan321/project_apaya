class User {
  final String name;
  final String email;
  final String? imageUrl;

  User({
    required this.name,
    required this.email,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      imageUrl: json['image_url'],
    );
  }
}

class ClassData {
  final int id;
  final String namaKelas;
  final int userId;

  ClassData({
    required this.id,
    required this.namaKelas,
    required this.userId,
  });

  factory ClassData.fromJson(Map<String, dynamic> json) {
    return ClassData(
      id: json['id'] ?? 0,
      namaKelas: json['nama_kelas'] ?? 'Tidak diketahui',
      userId: json['user_id'] ?? 0,
    );
  }
}
