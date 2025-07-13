import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:http/http.dart' as http;

/*───────────────────────────*/
/*  Utility ➜ buka WhatsApp  */
/*───────────────────────────*/
Future<bool> openWhatsApp({
  required String phone,
  required String message,
}) async {
  final normalized = phone.replaceAll(RegExp(r'[^0-9]'), '');
  final encoded = Uri.encodeComponent(message);

  if (Platform.isAndroid) {
    final intent = AndroidIntent(
      action: 'action_view',
      data: 'https://wa.me/$normalized?text=$encoded',
      package: 'com.whatsapp',
    );
    try {
      await intent.launch();
      return true;
    } catch (_) {
      final biz = AndroidIntent(
        action: 'action_view',
        data: 'https://wa.me/$normalized?text=$encoded',
        package: 'com.whatsapp.w4b',
      );
      try {
        await biz.launch();
        return true;
      } catch (_) {
        return false;
      }
    }
  } else if (Platform.isIOS) {
    final uri = Uri.parse('whatsapp://send?phone=$normalized&text=$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
  }
  return false;
}

/*───────────────────────────*/
/*  Page ➜ Siswa bolong ≠ 0   */
/*───────────────────────────*/
class StatusAkunSiswaInGuruPage extends StatefulWidget {
  const StatusAkunSiswaInGuruPage({super.key});

  @override
  State<StatusAkunSiswaInGuruPage> createState() =>
      _StatusAkunSiswaInGuruPageState();
}

class _StatusAkunSiswaInGuruPageState extends State<StatusAkunSiswaInGuruPage> {
  List<Map<String, String>> _akunSiswa = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /*───────────────────────────*/
  /*  Fetch kelas + phone-book  */
  /*───────────────────────────*/
  Future<void> _loadData() async {
    setState(() => _loading = true);

    try {
      /* fetch kedua endpoint paralel */
      final responses = await Future.wait([
        http.get(Uri.parse('https://absen.randijourney.my.id/api/v1/kelas')),
        http.get(Uri.parse('https://absen.randijourney.my.id/api/v1/account')),
      ]);

      final kelasRes = responses[0];
      final accountRes = responses[1];

      if (kelasRes.statusCode != 200) {
        throw 'kelas HTTP ${kelasRes.statusCode}';
      }
      if (accountRes.statusCode != 200) {
        throw 'account HTTP ${accountRes.statusCode}';
      }

      /* ---------- phone-book dari /account ---------- */
      final List<dynamic> accRows = jsonDecode(accountRes.body);
      final Map<String, String> phoneBook = {
        for (final r in accRows)
          (r['name']?.toString().toLowerCase() ?? ''):
              (r['nomor_telfon']?.toString() ?? '')
      };

      /* ---------- hitung bolong dari /kelas ---------- */
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

          final ket = s['keterangan']?.toString().toLowerCase() ?? '';
          if (ket != 'tidak hadir') continue;

          /* jika phone kosong → cari di phone-book berdasarkan nama */
          if (phone.isEmpty || phone == '-') {
            phone = phoneBook[namaKey] ?? '-';
          }

          final key = '$nama|$email';
          counter[key] ??= {
            'nama': nama,
            // 'email': email,
            'kelas': kelasNama,
            'noOrtu': phone,
            'bolong': 0,
          };
          counter[key]!['bolong'] = (counter[key]!['bolong'] as int) + 1;
        }
      }

      _akunSiswa = counter.values
          .map<Map<String, String>>((m) => {
                'nama': m['nama'],
                // 'email': m['email'],
                'kelas': m['kelas'],
                'noOrtu': (m['noOrtu'] as String).isEmpty ? '-' : m['noOrtu'],
                'tidakHadir': (m['bolong']).toString(),
              })
          .toList();

      setState(() => _loading = false);
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  Future<void> _handleRefresh() => _loadData();

  /*───────────────────────────*/
  /*  UI                       */
  /*───────────────────────────*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Siswa Tidak Hadir',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.lightBlueAccent,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _akunSiswa.isEmpty
                  ? const Center(
                      child: Text('Semua siswa hadir 🎉',
                          style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _akunSiswa.length,
                      itemBuilder: (_, i) {
                        final s = _akunSiswa[i];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(s['nama'] ?? '',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.deepPurple)),
                                      // Text(s['email'] ?? ''),
                                      const SizedBox(height: 4),
                                      Text('Kelas : ${s['kelas']}'),
                                      Text('No. HP Ortu : ${s['noOrtu']}'),
                                      const SizedBox(height: 6),
                                      Text('Tidak hadir: ${s['tidakHadir']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red)),
                                      const SizedBox(height: 10),
                                      InkWell(
                                        onTap: () async {
                                          final ok = await openWhatsApp(
                                            phone: s['noOrtu'] ?? '',
                                            message:
                                                'Halo Orang Tua dari ${s['nama']}, siswa Anda tercatat tidak hadir sebanyak ${s['tidakHadir']} kali.',
                                          );
                                          if (!ok && mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'WhatsApp tidak ditemukan di perangkat')));
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
                                                    fontWeight:
                                                        FontWeight.w600)),
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
      ),
    );
  }
}
