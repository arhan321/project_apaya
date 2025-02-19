class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? umur;
  final String? agama;
  final String? waliMurid;
  final String? imageUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.umur,
    this.agama,
    this.waliMurid,
    this.imageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      umur: json['umur']?.toString(),
      agama: json['agama'],
      waliMurid: json['wali_murid'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'umur': umur,
      'agama': agama,
      'wali_murid': waliMurid,
      'image_url': imageUrl,
    };
  }
}
