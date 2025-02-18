class SiswaAkunModel {
  final String id;
  final String foto; // Ditambahkan properti foto
  final String nama;
  final String email;
  final String password;
  final String noAbsen;
  final String? tanggalLahir; // Opsional

  SiswaAkunModel({
    required this.id,
    required this.foto,
    required this.nama,
    required this.email,
    required this.password,
    required this.noAbsen,
    this.tanggalLahir,
  });

  /// Factory constructor untuk mengonversi JSON (atau Map) ke objek SiswaAkunModel
  factory SiswaAkunModel.fromJson(Map<String, dynamic> json) {
    return SiswaAkunModel(
      id: json['id']?.toString() ?? '',
      foto: json['foto'] ??
          '', // Pastikan key-nya sesuai dengan data API (misal, 'foto' atau 'image_url')
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      noAbsen: json['no_absen']?.toString() ?? '',
      tanggalLahir: json['tanggal_lahir'],
    );
  }

  @override
  String toString() {
    return 'SiswaAkunModel(id: $id, foto: $foto, nama: $nama, email: $email, noAbsen: $noAbsen, tanggalLahir: $tanggalLahir)';
  }
}
