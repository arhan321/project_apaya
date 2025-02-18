class KelasModel {
  final int id;
  final String namaKelas;
  final String namaUser; // misal: wali kelas atau nama guru

  KelasModel({
    required this.id,
    required this.namaKelas,
    required this.namaUser,
  });

  /// Factory constructor untuk parsing dari JSON
  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      namaKelas: json['nama_kelas'] ?? 'Tidak Ada Nama',
      namaUser: json['nama_user'] ?? 'Tidak Ada Wali',
    );
  }
}
