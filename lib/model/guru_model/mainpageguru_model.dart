class User {
  final String name;
  final String email;
  final String role;
  final String? imageUrl;

  User({
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      role: json['role'] ?? 'Role tidak diketahui',
      imageUrl: json['image_url'],
    );
  }
}
