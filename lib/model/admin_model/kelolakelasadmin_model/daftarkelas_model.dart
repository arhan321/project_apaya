class KelasModel {
  final int id;
  final String namaKelas;
  final String waliKelas;
  final int userId; // Add userId field

  KelasModel({
    required this.id,
    required this.namaKelas,
    required this.waliKelas,
    required this.userId, // Initialize userId in constructor
  });

  // Factory constructor for KelasModel from JSON
  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id'],
      namaKelas: json['nama_kelas'] ?? 'Tidak Ada Nama',
      waliKelas: json['wali_kelas'] ?? 'Tidak Ada Wali',
      userId: json['user_id'] ?? 0, // Parse userId from JSON
    );
  }

  @override
  String toString() {
    return 'KelasModel(id: $id, namaKelas: $namaKelas, waliKelas: $waliKelas, userId: $userId)';
  }
}
