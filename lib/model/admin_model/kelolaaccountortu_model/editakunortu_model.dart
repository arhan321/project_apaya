class OrtuAkunModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String foto;

  OrtuAkunModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.foto,
  });

  /// Factory constructor untuk mengonversi JSON (atau Map) ke objek OrtuAkunModel
  factory OrtuAkunModel.fromJson(Map<String, dynamic> json) {
    return OrtuAkunModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      foto: json['foto'] ?? '', // Pastikan key ini sesuai dengan data API
    );
  }

  @override
  String toString() {
    return 'OrtuAkunModel(id: $id, name: $name, username: $username, email: $email, foto: $foto)';
  }
}
