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
          decoration: const BoxDecoration(
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () => Get.toNamed('/profilOrtu'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
            // Tidak perlu _buildSearchAndFilter() terpisah lagi
            Expanded(child: _buildStudentList()),
          ],
        );
      }),
    );
  }

  /// Bagian Header: menampilkan info guru, tanggal, hari,
  /// serta menampilkan Search Bar + Icon Filter
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
          const SizedBox(height: 4),

          /// Menampilkan Nama Guru
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
          const SizedBox(height: 8),
          // Baris Tanggal dan Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
              Text(
                dayOfWeek,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Baris Search Bar + Icon Filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: controller.filterStudents,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cari Nama Siswa',
                    hintStyle: GoogleFonts.poppins(fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  _showFilterBottomSheet();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bottom Sheet Filter
  void _showFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Absensi',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.select_all),
              title: Text('Semua', style: GoogleFonts.poppins()),
              onTap: () {
                controller.applyFilter('Semua');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text('Hadir', style: GoogleFonts.poppins()),
              onTap: () {
                controller.applyFilter('Hadir');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: Text('Izin', style: GoogleFonts.poppins()),
              onTap: () {
                controller.applyFilter('Izin');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: Text('Sakit', style: GoogleFonts.poppins()),
              onTap: () {
                controller.applyFilter('Sakit');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: Text('Tidak Hadir', style: GoogleFonts.poppins()),
              onTap: () {
                controller.applyFilter('Tidak Hadir');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredStudents.length,
        itemBuilder: (context, index) {
          final student = controller.filteredStudents[index];
          return AbsenCard(
            name: student['nama'] ?? 'Tidak diketahui',
            number: 'No ${student['nomor_absen'] ?? '-'}',
            status: student['keterangan'] ?? 'Tidak diketahui',
            statusColor: controller.getStatusColor(
              student['keterangan'] ?? 'Tidak diketahui',
            ),
            kelasid: student['kelas'] ?? 'Tidak diketahui',
            time: student['jam_absen'] ?? 'Tidak diketahui',
            tanggal: student['tanggal_absen'] ?? 'Tidak diketahui',
            catatan: student['catatan'] ?? 'Tidak ada catatan',
          );
        },
      ),
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
    Key? key,
    required this.name,
    required this.status,
    required this.statusColor,
    required this.number,
    required this.kelasid,
    required this.time,
    required this.tanggal,
    required this.catatan,
  }) : super(key: key);

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Nama, No Absen, Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kolom Kiri: Nama & Nomor Absen
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
                  const SizedBox(height: 4),
                  Text(
                    number,
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Tampilkan Tanggal
                  Text(
                    'Tanggal: $tanggal',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Tampilkan Jam
                  Text(
                    'Jam: $time',
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              // Status di sisi kanan
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
          const SizedBox(height: 12),

          // Tombol Aksi
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
              const SizedBox(width: 8),
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
