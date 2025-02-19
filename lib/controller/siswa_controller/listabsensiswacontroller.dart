import 'dart:convert';
import 'package:get/get.dart';
import '../../model/siswa_model/listabsensiswa_model.dart';

class ListAbsenController extends GetxController {
  final int classId;
  ListAbsenController({required this.classId});

  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var className = ''.obs;
  var students = <Map<String, dynamic>>[].obs;
  var filteredStudents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClassData();
  }

  Future<void> fetchClassData() async {
    const String urlBase = 'https://absen.randijourney.my.id/api/v1/kelas/';
    final String url = '$urlBase$classId';

    try {
      isLoading(true);
      errorMessage('');

      final response = await GetConnect().get(url);

      if (response.statusCode == 200) {
        final data = response.body['data'];

        className.value = data['nama_kelas'] ?? 'Tidak diketahui';
        students.assignAll((jsonDecode(data['siswa']) as List)
            .map((e) => e as Map<String, dynamic>)
            .toList());
        filteredStudents.assignAll(students);
      } else {
        errorMessage('Gagal memuat data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan saat memuat data.');
    } finally {
      isLoading(false);
    }
  }

  void filterStudents(String query) {
    filteredStudents.assignAll(students
        .where((student) =>
            student['nama']?.toLowerCase()?.contains(query.toLowerCase()) ??
            false)
        .toList());
  }

  void applyFilter(String status) {
    if (status == "Semua") {
      filteredStudents.assignAll(students);
    } else {
      filteredStudents.assignAll(students
          .where((student) => student['keterangan'] == status)
          .toList());
    }
  }
}
