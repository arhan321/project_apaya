import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusAkunSiswa extends StatelessWidget {
  final List<Map<String, String>> akunSiswa = [
    {
      'nama': 'Ahmad Faiz',
      'email': 'ahmadfaiz@email.com',
      'kelas': 'X IPA 1',
      'ttl': 'Bandung, 12 Jan 2007',
      'absen': '10',
      'noOrtu': '6289652731947',
      'tidakHadir': '3',
    },
    {
      'nama': 'Bunga Lestari',
      'email': 'bunga@email.com',
      'kelas': 'XI IPS 2',
      'ttl': 'Jakarta, 5 Mei 2006',
      'absen': '07',
      'noOrtu': '6282112125639',
      'tidakHadir': '2',
    },
  ];

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
        child: ListView.builder(
          itemCount: akunSiswa.length,
          itemBuilder: (context, index) {
            final siswa = akunSiswa[index];
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
                            siswa['nama'] ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(siswa['email'] ?? ''),
                          SizedBox(height: 4),
                          Text('Kelas: ${siswa['kelas']}'),
                          Text('TTL: ${siswa['ttl']}'),
                          Text('No. Absen: ${siswa['absen']}'),
                          Text('No. HP Ortu: ${siswa['noOrtu']}'),
                          SizedBox(height: 6),
                          Text(
                            'Tidak hadir: ${siswa['tidakHadir']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              final noHp = siswa['noOrtu']!;
                              final nama = siswa['nama']!;
                              final url =
                                  'https://wa.me/$noHp?text=Halo%20Orang%20Tua%20dari%20$nama%2C%20kami%20ingin%20menyampaikan%20informasi%20kehadiran.';

                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Tidak bisa membuka WhatsApp')),
                                );
                              }
                            },
                            child: Row(
                              children: [
                               FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),

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
