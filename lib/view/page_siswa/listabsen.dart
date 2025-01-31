import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/siswa_controller/listabsensiswacontroller.dart';

class ListAbsenPage extends StatelessWidget {
  final int classId;
  ListAbsenPage({required this.classId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListAbsenController(classId: classId));

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Obx(() => Text(
              'Absen ${controller.className.value}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          );
        }

        return Column(
          children: [
            _buildHeader(controller),
            _buildFilterBar(controller),
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = controller.filteredStudents[index];
                      return _buildAbsenCard(
                        controller:
                            controller, // Tambahkan controller ke fungsi ini
                        name: student['nama'] ?? 'Tidak diketahui',
                        number: 'No ${student['nomor_absen'] ?? '-'}',
                        badge: student['keterangan'] ?? 'Tidak diketahui',
                        jamAbsen: student['jam_absen'] ?? '-',
                      );
                    },
                  )),
            ),
            _buildAbsenButton(controller.classId),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(ListAbsenController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Kelas:',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
          ),
          Obx(() => Text(
                controller.className.value,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
          SizedBox(height: 4),
          Text(
            "2025-09-12",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) => controller.filterStudents(value),
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Cari Nama Siswa',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(ListAbsenController controller) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterButton(controller, 'Semua'),
          _buildFilterButton(controller, 'Hadir'),
          _buildFilterButton(controller, 'Izin'),
          _buildFilterButton(controller, 'Sakit'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(ListAbsenController controller, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: () => controller.applyFilter(status),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        child: Text(
          status,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAbsenCard({
    required ListAbsenController controller,
    required String name,
    required String number,
    required String badge,
    required String jamAbsen,
  }) {
    Color badgeColor;
    switch (badge) {
      case 'Hadir':
        badgeColor = Colors.green;
        break;
      case 'Izin':
        badgeColor = Colors.orange;
        break;
      case 'Sakit':
        badgeColor = Colors.blue;
        break;
      case 'Tidak Hadir':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text(number,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey)),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: badgeColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Get.toNamed(
              '/viewDetail',
              arguments: {
                'name': name,
                'number': number,
                'kelas': controller.className.value, // **PERBAIKAN DI SINI**
                'keterangan': badge,
                'jamAbsen': jamAbsen,
              },
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Warna konsisten biru
            ),
            child: Text(
              'Lihat Detail',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenButton(int classId) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () =>
            Get.toNamed('/formAbsen', arguments: {'classId': classId}),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text('Silahkan Absen',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
