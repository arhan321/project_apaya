class EditProfileSiswaModel {
  String? id;
  String? name;
  String? kelas;
  String? nomorAbsen;
  String? tanggalLahir;
  String? agama;
  String? nisn;
  String? umur;
  String? imageUrl;

  EditProfileSiswaModel({
    this.id,
    this.name,
    this.kelas,
    this.nomorAbsen,
    this.tanggalLahir,
    this.agama,
    this.nisn,
    this.umur,
    this.imageUrl,
  });

  factory EditProfileSiswaModel.fromJson(Map<String, dynamic> json) {
    return EditProfileSiswaModel(
      id: json['id']?.toString(),
      name: json['name'],
      kelas: json['kelas'],
      nomorAbsen: json['nomor_absen']?.toString(),
      tanggalLahir: json['tanggal_lahir'],
      agama: json['agama'],
      nisn: json['nisn']?.toString(),
      umur: json['umur'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kelas': kelas,
      'nomor_absen': nomorAbsen,
      'tanggal_lahir': tanggalLahir,
      'agama': agama,
      'nisn': nisn,
      'umur': umur,
      'image_url': imageUrl,
    };
  }
}
