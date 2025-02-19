// Model untuk merepresentasikan data siswa absen
import 'package:flutter/material.dart';

class SiswaAbsen {
  final int id;
  final String name;
  final int nomorAbsen;
  final String kelas;
  final String status;
  final String time;
  final String catatan;
  final String tanggalAbsen;
  final Color color;

  SiswaAbsen({
    required this.id,
    required this.name,
    required this.nomorAbsen,
    required this.kelas,
    required this.status,
    required this.time,
    required this.catatan,
    required this.tanggalAbsen,
    required this.color,
  });

  factory SiswaAbsen.fromJson(Map<String, dynamic> json, String kelas) {
    return SiswaAbsen(
      id: json['id'],
      name: json['nama'],
      nomorAbsen: json['nomor_absen'],
      kelas: kelas,
      status: json['keterangan'],
      time: json['jam_absen'],
      catatan: json['catatan'] ?? '-',
      tanggalAbsen: json['tanggal_absen'] ?? '-',
      color: _getStatusColor(json['keterangan']),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'sakit':
        return Colors.blue;
      case 'izin':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
