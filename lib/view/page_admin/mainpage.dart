import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controller/admin_controller/mainpageadmin_controller.dart';
import '/routes/routes.dart';

class AdminDashboard extends StatelessWidget {
  final MainPageAdminController controller = Get.put(MainPageAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Dashboard Admin',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              Get.toNamed('/profileAdmin');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else {
          return _buildDashboardContent(context);
        }
      }),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Obx(() {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                controller.adminName.value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                controller.adminEmail.value,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: controller.userImageUrl.value != null
                    ? NetworkImage(controller.userImageUrl.value!)
                    : null,
                child: controller.userImageUrl.value == null
                    ? Text(
                        controller.adminName.value.isNotEmpty
                            ? controller.adminName.value[0]
                            : 'A',
                        style: GoogleFonts.poppins(
                          fontSize: 40.0,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blueAccent),
              title: Text(
                'Home',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.refresh, color: Colors.blueAccent),
              title: Text(
                'Refresh (jika data tidak valid)',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                controller
                    .fetchAdminData(); // Memanggil metode untuk refresh data
                Get.snackbar(
                  'Refresh',
                  'Data berhasil diperbarui!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.class_, color: Colors.blueAccent),
              title: Text(
                'Tambah Kelas',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.daftarKelas);
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.blueAccent),
              title: Text(
                'Kelola Pengguna',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.toNamed('/listAccount');
              },
            ),
            ListTile(
              leading: Icon(Icons.checklist, color: Colors.blueAccent),
              title: Text(
                'Kelola Absensi',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.toNamed('/kelolaAbsensi');
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart, color: Colors.blueAccent),
              title: Text(
                'Laporan',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                Get.toNamed('/rekapAdmin');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueAccent),
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(),
              ),
              onTap: () {
                controller.logout();
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio:
                    MediaQuery.of(context).size.width < 600 ? 3 : 2.5,
                children: [
                  _buildFeatureCard(
                    title: 'Tambah Kelas',
                    subtitle: 'Tambahkan kelas baru dan edit ke sistem.',
                    icon: Icons.class_,
                    onTap: () {
                      Get.toNamed(AppRoutes.daftarKelas);
                    },
                  ),
                  _buildFeatureCard(
                    title: 'Kelola Pengguna',
                    subtitle: 'Tambah, ubah, atau hapus pengguna.',
                    icon: Icons.people,
                    onTap: () {
                      Get.toNamed('/listAccount');
                    },
                  ),
                  _buildFeatureCard(
                    title: 'Kelola Absensi',
                    subtitle: 'Pantau dan ubah data absensi.',
                    icon: Icons.checklist,
                    onTap: () {
                      Get.toNamed('/kelolaAbsensi');
                    },
                  ),
                  _buildFeatureCard(
                    title: 'Laporan',
                    subtitle: 'Lihat dan unduh laporan absensi.',
                    icon: Icons.insert_chart,
                    onTap: () {
                      Get.toNamed('/rekapAdmin');
                    },
                  ),
                ],
              ),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          controller.logout();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Logout',
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
