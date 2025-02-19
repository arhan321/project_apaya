class Student {
  final int id;
  final String nama;
  final String keterangan;

  Student({
    required this.id,
    required this.nama,
    required this.keterangan,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      nama: json['nama'] as String,
      keterangan: json['keterangan'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'keterangan': keterangan,
    };
  }
}
