class Absen {
  final int id;
  final String nama;
  final String nomorAbsen;
  final String kelas;
  final String keterangan;
  final String jamAbsen;
  final String catatan;
  final String tanggalAbsen;

  Absen({
    required this.id,
    required this.nama,
    required this.nomorAbsen,
    required this.kelas,
    required this.keterangan,
    required this.jamAbsen,
    required this.catatan,
    required this.tanggalAbsen,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
      "nomor_absen": nomorAbsen,
      "kelas": kelas,
      "keterangan": keterangan,
      "jam_absen": jamAbsen,
      "catatan": catatan.isEmpty ? "Tidak ada catatan" : catatan,
      "tanggal_absen": tanggalAbsen,
    };
  }
}
