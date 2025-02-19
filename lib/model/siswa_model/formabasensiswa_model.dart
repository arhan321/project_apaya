class SiswaAbsenModel {
  String? id;
  String? nama;
  String? kelas;
  String? nis;
  String? tanggalAbsen;
  String? statusAbsen;

  SiswaAbsenModel({
    this.id,
    this.nama,
    this.kelas,
    this.nis,
    this.tanggalAbsen,
    this.statusAbsen,
  });

  factory SiswaAbsenModel.fromJson(Map<String, dynamic> json) {
    return SiswaAbsenModel(
      id: json['id']?.toString(),
      nama: json['nama'],
      kelas: json['kelas'],
      nis: json['nis']?.toString(),
      tanggalAbsen: json['tanggal_absen'],
      statusAbsen: json['status_absen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kelas': kelas,
      'nis': nis,
      'tanggal_absen': tanggalAbsen,
      'status_absen': statusAbsen,
    };
  }
}
