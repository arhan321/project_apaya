import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAdminController extends GetxController {
  final Dio _dio = Dio();

  /// Variabel-variabel yang semula di dalam State, sekarang dijadikan reaktif (Rx)
  var adminName = ''.obs;
  var role = 'Administrator'.obs;
  var photoUrl = ''.obs;
  var birthDate = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Fungsi untuk mengambil data user dari API
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

        adminName.value = data['name'] ?? 'Nama tidak tersedia';
        photoUrl.value = data['image_url'] ?? '';
        birthDate.value =
            data['tanggal_lahir'] ?? 'Tanggal lahir tidak tersedia';
        isLoading.value = false;
      } else {
        errorMessage.value =
            'Gagal mengambil data. Status Code: ${response.statusCode}\nPesan: ${response.data}';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data.';
      isLoading.value = false;
    }
  }

  /// Fungsi untuk navigasi ke halaman edit profile
  void editProfile() {
    Get.toNamed('/editAkunAdmin');
  }

  /// Fungsi untuk menghapus akun (logout)
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
        await prefs.clear();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', 'Gagal menghapus akun');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat menghapus akun');
    }
  }
}
