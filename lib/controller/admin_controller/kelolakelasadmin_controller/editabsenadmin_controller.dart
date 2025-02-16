import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class EditAbsenAdminController extends GetxController {
  final Dio dio = Dio();

  Future<Map<String, dynamic>> updateAbsen({
    required int kelasId,
    required int siswaId,
    required String nama,
    required String nomorAbsen,
    required String jamAbsen,
    required String status,
    required String tanggalAbsen,
  }) async {
    final String url =
        'https://absen.randijourney.my.id/api/v1/kelas/update/$kelasId';

    try {
      debugPrint('Sending data to API...');
      debugPrint('URL: $url');
      debugPrint('Payload: ${{
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
      }}');

      final response = await dio.put(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'siswa': [
            {
              'id': siswaId,
              'nama': nama,
              'nomor_absen': nomorAbsen,
              'keterangan': status,
              'jam_absen': jamAbsen,
              'tanggal_absen': tanggalAbsen,
            }
          ],
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Data berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Gagal memperbarui data',
          'error': response.data,
        };
      }
    } catch (e) {
      debugPrint('Error during API call: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat menghubungi server.',
        'error': e.toString(),
      };
    }
  }
}
