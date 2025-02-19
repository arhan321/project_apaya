class UserModel {
  final String name;
  final String email;
  final String role;
  final String? imageUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      role: json['role'] ?? 'Role tidak diketahui',
      imageUrl: json['image_url'],
    );
  }
}
