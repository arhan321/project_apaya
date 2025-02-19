class User {
  final String name;
  final String email;
  final String? imageUrl;
  final String childName;

  User({
    required this.name,
    required this.email,
    this.imageUrl,
    required this.childName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Nama tidak tersedia',
      email: json['email'] ?? 'Email tidak tersedia',
      imageUrl: json['image_url'],
      childName: _parseChildName(json['wali_murid']),
    );
  }

  static String _parseChildName(dynamic waliMurid) {
    if (waliMurid is String) {
      return waliMurid.isNotEmpty ? waliMurid : 'Nama Anak Tidak Ditemukan';
    } else if (waliMurid is Map) {
      return waliMurid['nama_anak'] ?? 'Nama Anak Tidak Ditemukan';
    }
    return 'Nama Anak Tidak Ditemukan';
  }
}
