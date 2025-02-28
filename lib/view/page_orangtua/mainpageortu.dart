import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/controller/orangtua_controller/mainpageortu_controller.dart';
import 'listabsenortu.dart';
import 'profilortu.dart';

class MainPageOrtu extends StatefulWidget {
  @override
  _MainPageOrtuState createState() => _MainPageOrtuState();
}

class _MainPageOrtuState extends State<MainPageOrtu> {
  final MainPageOrtuController controller = Get.put(MainPageOrtuController());

  @override
  void initState() {
    super.initState();
    controller.fetchUserData(); // Fetch user data
    controller.fetchClassData(); // Fetch class data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      controller.fetchUserData(); // Refresh user data
      controller.fetchClassData(); // Refresh class data
    }
  }

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
          'Dashboard Orang Tua',
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
            icon: Icon(Icons.account_circle),
            color: Colors.white,
            onPressed: () {
              Get.to(() => ProfilortuPage());
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
          return _buildDashboardContent();
        }
      }),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Obx(() {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                controller.userName.value,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              accountEmail: Text(
                controller.userEmail.value,
                style: GoogleFonts.poppins(),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: controller.userImageUrl.value != null
                    ? NetworkImage(controller.userImageUrl.value!)
                    : null,
                child: controller.userImageUrl.value == null
                    ? Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value[0]
                            : 'G',
                        style: GoogleFonts.poppins(
                          fontSize: 40.0,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
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
                controller.fetchUserData();
                controller.fetchClassData();
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

  Widget _buildDashboardContent() {
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
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.classList.length,
                  itemBuilder: (context, index) {
                    final classData = controller.classList[index];
                    // Jika terdapat key 'siswa', kita asumsikan ada notifikasi jika tidak kosong
                    bool hasChanges = false;
                    if (classData.containsKey('siswa')) {
                      hasChanges = classData['siswa'] != '[]';
                    }
                    return _buildCard(
                      title: classData['nama_kelas'] ?? 'Tidak ada nama kelas',
                      subtitle:
                          'Pengajar: ${classData['nama_user'] ?? 'Tidak diketahui'}',
                      teacher: 'ID Kelas: ${classData['id'] ?? '-'}',
                      onTap: () {
                        Get.toNamed(
                          '/listAbsenOrtu',
                          arguments: {'classId': classData['id']},
                        );
                      },
                      showNotification: hasChanges,
                    );
                  },
                );
              }),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String teacher,
    required VoidCallback onTap,
    bool showNotification = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
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
        child: Stack(
          children: [
            Column(
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
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  teacher,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            if (showNotification)
              Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 10,
                  child: Icon(
                    Icons.notification_important,
                    color: Colors.white,
                    size: 12,
                  ),
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
          padding: EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Logout',
          style: GoogleFonts.poppins(
            color: Colors.blueAccent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
