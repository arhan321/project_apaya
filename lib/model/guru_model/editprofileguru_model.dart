class GuruProfile {
  String? id;
  String? name;
  String? nipGuru;
  String? agama;
  String? umur;
  String? waliKelas;
  String? tanggalLahir;
  String? imageUrl;

  GuruProfile({
    this.id,
    this.name,
    this.nipGuru,
    this.agama,
    this.umur,
    this.waliKelas,
    this.tanggalLahir,
    this.imageUrl,
  });

  factory GuruProfile.fromJson(Map<String, dynamic> json) {
    return GuruProfile(
      id: json['id']?.toString(),
      name: json['name'],
      nipGuru: json['nip_guru']?.toString(),
      agama: json['agama'],
      umur: json['umur'],
      waliKelas: json['wali_kelas'],
      tanggalLahir: json['tanggal_lahir'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nip_guru': nipGuru,
      'agama': agama,
      'umur': umur,
      'wali_kelas': waliKelas,
      'tanggal_lahir': tanggalLahir,
      'image_url': imageUrl,
    };
  }
}
