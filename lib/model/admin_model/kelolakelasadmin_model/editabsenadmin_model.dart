class AbsenData {
  final int siswaId;
  final String nama;
  final String nomorAbsen;
  final String jamAbsen;
  final String status;
  final String tanggalAbsen;

  AbsenData({
    required this.siswaId,
    required this.nama,
    required this.nomorAbsen,
    required this.jamAbsen,
    required this.status,
    required this.tanggalAbsen,
  });

  // Convert data to JSON format
  Map<String, dynamic> toJson() {
    return {
      'siswa': [
        {
          'id': siswaId,
          'nama': nama,
          'nomor_absen': nomorAbsen,
          'keterangan': status,
          'jam_absen': jamAbsen,
          'tanggal_absen': tanggalAbsen,
        }
      ]
    };
  }
}
