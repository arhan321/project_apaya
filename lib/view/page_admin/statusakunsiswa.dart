import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StatusAkunSiswa extends StatefulWidget {
  const StatusAkunSiswa({Key? key}) : super(key: key);

  @override
  State<StatusAkunSiswa> createState() => _StatusAkunSiswaPageState();
}

class _StatusAkunSiswaPageState extends State<StatusAkunSiswa> {
  bool isLoading = true;
  List<Map<String, dynamic>> siswaList = [];

  @override
  void initState() {
    super.initState();
    fetchSiswaData();
  }

  Future<void> fetchSiswaData() async {
    final url = Uri.parse("https://absen.randijourney.my.id/api/v1/account");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Map<String, dynamic>> filteredData = data
            .where((item) =>
                item is Map<String, dynamic> &&
                item['role'] != null &&
                item['role'].toString().toLowerCase() == 'siswa')
            .cast<Map<String, dynamic>>()
            .toList();

        setState(() {
          siswaList = filteredData;
          isLoading = false;
        });
      } else {
        throw Exception("Gagal memuat data");
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Akun Siswa',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        leading: BackButton(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
                itemCount: siswaList.length,
                itemBuilder: (context, index) {
                  final siswa = siswaList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.person, size: 50, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  siswa['name'] ?? '-',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(siswa['email'] ?? '-'),
                                SizedBox(height: 4),
                                Text('Kelas: ${siswa['kelas'] ?? '-'}'),
                                Text('TTL: ${siswa['tanggal_lahir'] ?? '-'}'),
                                Text(
                                    'No. Absen: ${siswa['nomor_absen'] ?? '-'}'),
                                Text(
                                    'No. HP Ortu: ${siswa['nomor_telfon'] ?? '-'}'),
                                SizedBox(height: 6),
                                Text(
                                  'Tidak hadir: ${siswa['tidak_hadir'] ?? '0'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () async {
                                    final noHp = siswa['nomor_telfon'] ?? '';
                                    final nama = siswa['name'] ?? '';
                                    final url =
                                        'https://wa.me/$noHp?text=Halo%20Orang%20Tua%20dari%20$nama%2C%20kami%20ingin%20menyampaikan%20informasi%20kehadiran.';

                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Tidak bisa membuka WhatsApp')),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.whatsapp,
                                          color: Colors.green),
                                      SizedBox(width: 8),
                                      Text(
                                        'Hubungi Orang Tua via WhatsApp',
                                        style: TextStyle(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
