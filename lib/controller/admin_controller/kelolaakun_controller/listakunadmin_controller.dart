import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ListAkunAdminController extends GetxController {
  final Dio dioClient = Dio();

  /// Menyimpan list akun admin
  var akunAdmin = <Map<String, dynamic>>[].obs;

  /// Menyimpan state loading
  var isLoading = true.obs;

  /// Menyimpan pesan error (jika ada)
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAkunAdmin();
  }

  /// Mengambil data akun admin dari server
  Future<void> fetchAkunAdmin() async {
    isLoading.value = true;
    errorMessage.value = '';

    const String url = 'https://absen.randijourney.my.id/api/v1/account';

    try {
      final response = await dioClient.get(
        url,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Filter hanya admin
        final filteredList = (data as List)
            .where((item) => (item['role'] ?? '').toLowerCase() == 'admin')
            .map((item) => {
                  'id': item['id']?.toString() ?? '',
                  'foto': item['image_url'] ?? '',
                  'username': item['name'] ?? 'Nama tidak tersedia',
                  'email': item['email'] ?? 'Email tidak tersedia',
                  'password': item['password'] ?? '********',
                  'role': item['role'] ?? '',
                  // Field tambahan:
                  'nomor_telfon': item['nomor_telfon']?.toString() ?? '',
                  'agama': item['agama']?.toString() ?? '',
                  'nip_guru': item['nip_guru']?.toString() ?? '',
                  'tanggal_lahir': item['tanggal_lahir']?.toString() ?? '',
                  'umur': item['umur']?.toString() ?? '',
                })
            .toList();

        akunAdmin.value = filteredList;
      } else {
        errorMessage.value =
            'Gagal memuat data. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fungsi untuk menghapus akun
  Future<void> deleteAkun(String id) async {
    const String baseUrl = 'https://absen.randijourney.my.id/api/v1/account/';
    try {
      final response = await dioClient.delete('$baseUrl$id');

      if (response.statusCode == 200) {
        // Hapus dari list
        akunAdmin.removeWhere((item) => item['id'] == id);

        Get.snackbar(
          'Sukses',
          'Akun berhasil dihapus.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Tidak dapat menghapus akun.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan saat menghapus akun: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
