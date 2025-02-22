import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class ProfilortuController extends GetxController {
  var parentName = ''.obs;
  var childName = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;
    errorMessage.value = '';

    const String url = 'https://absen.randijourney.my.id/auth/me';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        errorMessage.value = 'Token tidak ditemukan. Silakan login ulang.';
        isLoading.value = false;
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        parentName.value = data['name'] ?? 'Nama tidak tersedia';
        email.value = data['email'] ?? 'Email tidak tersedia';
        photoUrl.value = data['image_url'] ?? '';

        if (data['wali_murid'] is String) {
          childName.value = data['wali_murid'].toString().isNotEmpty
              ? data['wali_murid']
              : 'Nama Anak Tidak Ditemukan';
        } else {
          childName.value = (data['wali_murid'] != null &&
                  data['wali_murid'] is Map &&
                  data['wali_murid']['nama_anak'] != null)
              ? data['wali_murid']['nama_anak']
              : 'Nama Anak Tidak Ditemukan';
        }
        isLoading.value = false;
      } else {
        errorMessage.value =
            'Gagal mengambil data. Status Code: ${response.statusCode}';
        log('Error Fetching Data: ${response.data}',
            name: 'ProfilortuController');
        isLoading.value = false;
      }
    } catch (e, stackTrace) {
      errorMessage.value = _handleError(e);
      log('Exception: $e',
          name: 'ProfilortuController', error: e, stackTrace: stackTrace);
      isLoading.value = false;
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Koneksi timeout. Silakan coba lagi.';
        case DioExceptionType.badCertificate:
          return 'Sertifikat SSL tidak valid. Periksa koneksi Anda.';
        case DioExceptionType.cancel:
          return 'Permintaan dibatalkan.';
        case DioExceptionType.sendTimeout:
          return 'Waktu pengiriman data habis. Silakan coba lagi.';
        default:
          if (error.response != null) {
            return 'Kesalahan server. Status: ${error.response?.statusCode}';
          } else {
            return 'Kesalahan tak terduga: ${error.message}';
          }
      }
    } else {
      return 'Kesalahan tak terduga: $error';
    }
  }

  void navigateToEditProfile() {
    Get.toNamed('/editProfileOrtu');
  }

  Future<void> deleteAccount() async {
    const String url = 'https://absen.randijourney.my.id/api/v1/account/logout';

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        Get.offAllNamed('/login');
        return;
      }

      final response = await _dio.delete(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Akun berhasil dihapus');
        prefs.clear();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', 'Gagal menghapus akun');
      }
    } catch (e, stackTrace) {
      Get.snackbar('Error', 'Terjadi kesalahan saat menghapus akun');
      log('Exception in deleteAccount: $e',
          name: 'ProfilortuController', error: e, stackTrace: stackTrace);
    }
  }
}
