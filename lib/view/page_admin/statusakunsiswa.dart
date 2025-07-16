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
    setState(() => isLoading = true);
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://absen.randijourney.my.id/api/v1/kelas')),
        http.get(Uri.parse('https://absen.randijourney.my.id/api/v1/account')),
      ]);

      final kelasRes = responses[0];
      final accountRes = responses[1];

      if (kelasRes.statusCode != 200) throw 'kelas HTTP ${kelasRes.statusCode}';
      if (accountRes.statusCode != 200)
        throw 'account HTTP ${accountRes.statusCode}';

      final List<dynamic> accRows = jsonDecode(accountRes.body);
      final Map<String, String> phoneBook = {
        for (final r in accRows)
          (r['name']?.toString().toLowerCase() ?? ''):
              (r['nomor_telfon']?.toString() ?? '')
      };

      final List<dynamic> kelasRows =
          (jsonDecode(kelasRes.body)['data'] ?? []) as List<dynamic>;

      final Map<String, Map<String, dynamic>> counter = {};

      for (final k in kelasRows) {
        final kelasNama = k['nama_kelas']?.toString() ?? '-';
        final siswaRaw = k['siswa'] ?? '[]';

        List<dynamic> siswaList;
        try {
          siswaList = jsonDecode(siswaRaw);
        } catch (_) {
          continue;
        }

        for (final s in siswaList) {
          final nama = s['nama']?.toString() ?? '-';
          final namaKey = nama.toLowerCase();
          final email = s['email']?.toString() ?? '-';
          var phone = (s['nomor_telfon']?.toString() ?? '').trim();
          final absen = s['nomor_absen'] ?? '-';
          final ttl = s['tanggal_lahir'] ?? '-';

          final ket = s['keterangan']?.toString().toLowerCase() ?? '';
          if (ket != 'tidak hadir') continue;

          if (phone.isEmpty || phone == '-') {
            phone = phoneBook[namaKey] ?? '-';
          }

          final key = '$nama|$email';
          counter[key] ??= {
            'nama': nama,
            'email': email,
            'kelas': kelasNama,
            'noOrtu': phone,
            'absen': absen,
            'ttl': ttl,
            'bolong': 0,
          };
          counter[key]!['bolong'] = (counter[key]!['bolong'] as int) + 1;
        }
      }

      siswaList = counter.values
          .where((m) => (m['bolong'] as int) >= 3)
          .map<Map<String, dynamic>>((m) => {
                'name': m['nama'],
                'email': m['email'],
                'kelas': m['kelas'],
                'nomor_telfon': m['noOrtu'],
                'nomor_absen': m['absen'],
                // 'tanggal_lahir': m['ttl'],
                'tidak_hadir': m['bolong'].toString(),
              })
          .toList();

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("ERROR: $e");
      setState(() => isLoading = false);
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
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white))
            : siswaList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada siswa yang bolong ≥ 3',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: siswaList.length,
                    itemBuilder: (context, index) {
                      final siswa = siswaList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.person,
                                  size: 50, color: Colors.grey),
                              const SizedBox(width: 12),
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
                                    // Text(siswa['email'] ?? '-'),
                                    const SizedBox(height: 4),
                                    Text('Kelas: ${siswa['kelas'] ?? '-'}'),
                                    // Text(
                                    //     'TTL: ${siswa['tanggal_lahir'] ?? '-'}'),
                                    Text(
                                        'No. Absen: ${siswa['nomor_absen'] ?? '-'}'),
                                    Text(
                                        'No. HP Ortu: ${siswa['nomor_telfon'] ?? '-'}'),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Tidak hadir: ${siswa['tidak_hadir'] ?? '0'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () async {
                                        final noHp =
                                            siswa['nomor_telfon'] ?? '';
                                        final nama = siswa['name'] ?? '';
                                        final message = Uri.encodeComponent(
                                            'Halo Orang Tua dari $nama, siswa Anda tercatat tidak hadir sebanyak ${siswa['tidak_hadir']} kali.');
                                        final url =
                                            'https://wa.me/$noHp?text=$message';

                                        if (await canLaunchUrl(
                                            Uri.parse(url))) {
                                          await launchUrl(Uri.parse(url),
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Tidak bisa membuka WhatsApp')),
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const FaIcon(
                                              FontAwesomeIcons.whatsapp,
                                              color: Colors.green),
                                          const SizedBox(width: 8),
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
