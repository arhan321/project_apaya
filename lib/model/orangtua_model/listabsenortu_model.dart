class Student {
  final int id;
  final String nama;
  final String? keterangan;

  Student({
    required this.id,
    required this.nama,
    this.keterangan,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      keterangan: json['keterangan'],
    );
  }
}
