class GuruAkunModel {
  final String id;
  final String nama;
  final String email;
  final String password;
  final String? tanggalLahir;
  final String foto;

  GuruAkunModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.tanggalLahir,
    required this.foto,
  });

  /// Factory constructor untuk mengonversi JSON/Map ke objek GuruAkunModel
  factory GuruAkunModel.fromJson(Map<String, dynamic> json) {
    return GuruAkunModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      tanggalLahir: json['tanggal_lahir'],
      foto: json['foto'] ?? '', // Pastikan key-nya sesuai dengan API
    );
  }

  @override
  String toString() {
    return 'GuruAkunModel(id: $id, nama: $nama, email: $email, tanggalLahir: $tanggalLahir, foto: $foto)';
  }
}
