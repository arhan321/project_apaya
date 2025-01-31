import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controller/orangtua_controller/listabsenortu_controller.dart';

class ListAbsenOrtu extends StatefulWidget {
  final int classId;

  const ListAbsenOrtu({Key? key, required this.classId}) : super(key: key);

  @override
  _ListAbsenOrtuState createState() => _ListAbsenOrtuState();
}

class _ListAbsenOrtuState extends State<ListAbsenOrtu> {
  final controller = Get.put(ListAbsenOrtuController());

  @override
  void initState() {
    super.initState();
    controller.fetchClassData(widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final List<String> daysInWeek = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final String dayOfWeek = daysInWeek[now.weekday % 7];

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
                color: Colors.white,
              ),
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Get.toNamed('/profilOrtu'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          );
        }

        return Column(
          children: [
            _buildHeader(formattedDate, dayOfWeek),
            _buildSearchAndFilter(),
            _buildStudentList(),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(String formattedDate, String dayOfWeek) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang Wali Murid',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),

          /// Menampilkan Nama Guru dengan Handling Loading & Error
          Obx(() {
            if (controller.isLoading.value) {
              return Text(
                "Guru: Loading...",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              );
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Text(
                "Guru: Data gagal dimuat",
                style:
                    GoogleFonts.poppins(fontSize: 16, color: Colors.redAccent),
              );
            }

            return Text(
              "Guru: ${controller.namaUser.value.isNotEmpty ? controller.namaUser.value : 'Tidak diketahui'}",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            );
          }),

          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
              Text(dayOfWeek,
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: controller.filterStudents,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Cari Nama Siswa',
          hintStyle: GoogleFonts.poppins(fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return Expanded(
      child: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredStudents.length,
            itemBuilder: (context, index) {
              final student = controller.filteredStudents[index];
              return AbsenCard(
                name: student['nama'] ?? 'Tidak diketahui',
                number: 'No ${student['nomor_absen'] ?? '-'}',
                status: student['keterangan'] ?? 'Tidak diketahui',
                statusColor: controller
                    .getStatusColor(student['keterangan'] ?? 'Tidak diketahui'),
                kelasid: student['kelas'] ?? 'Tidak diketahui',
                time: student['jam_absen'] ?? 'Tidak diketahui',
                tanggal: student['tanggal_absen'] ?? 'Tidak diketahui',
                catatan: student['catatan'] ?? 'Tidak ada catatan',
              );
            },
          )),
    );
  }
}

class AbsenCard extends StatelessWidget {
  final String name;
  final String status;
  final Color statusColor;
  final String number;
  final String kelasid;
  final String time;
  final String tanggal;
  final String catatan;

  const AbsenCard({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.number,
    required this.kelasid,
    required this.time,
    required this.tanggal,
    required this.catatan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
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
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    number,
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/detailAbsenOrtu', arguments: {
                      'name': name,
                      'number': number,
                      'status': status,
                      'kelasid': kelasid,
                      'time': time,
                      'tanggal': tanggal,
                      'catatan': catatan,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Warna Biru
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Lihat Detail',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/cekCatatan', arguments: {
                      'name': name,
                      'tanggal': tanggal,
                      'time': time,
                      'catatan': catatan,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Warna Hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cek Catatan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
