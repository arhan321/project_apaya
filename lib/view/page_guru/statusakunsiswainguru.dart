import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

/// ---------------------------------------------------------------------------
/// Utility ➜ buka WhatsApp (Android & iOS)
/// ---------------------------------------------------------------------------
Future<bool> openWhatsApp({
  required String phone,
  required String message,
}) async {
  final normalized = phone.replaceAll(RegExp(r'[^0-9]'), '');
  final encodedMsg = Uri.encodeComponent(message);

  if (Platform.isAndroid) {
    final intent = AndroidIntent(
      action: 'action_view',
      data: 'https://wa.me/$normalized?text=$encodedMsg',
      package: 'com.whatsapp',
    );
    try {
      await intent.launch();
      return true;
    } catch (_) {
      final intentBiz = AndroidIntent(
        action: 'action_view',
        data: 'https://wa.me/$normalized?text=$encodedMsg',
        package: 'com.whatsapp.w4b',
      );
      try {
        await intentBiz.launch();
        return true;
      } catch (_) {
        return false;
      }
    }
  } else if (Platform.isIOS) {
    final uri = Uri.parse('whatsapp://send?phone=$normalized&text=$encodedMsg');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    return false;
  }
  return false;
}

/// ---------------------------------------------------------------------------
/// Page ➜ Daftar Siswa + Pull-to-Refresh + Tombol WhatsApp
/// ---------------------------------------------------------------------------
class StatusAkunSiswaInGuruPage extends StatefulWidget {
  const StatusAkunSiswaInGuruPage({super.key});

  @override
  State<StatusAkunSiswaInGuruPage> createState() =>
      _StatusAkunSiswaInGuruPageState();
}

class _StatusAkunSiswaInGuruPageState extends State<StatusAkunSiswaInGuruPage> {
  /// sumber data (dummy); ganti dengan fetch endpoint
  List<Map<String, String>> _akunSiswa = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// ambil data (simulasi API 1,5 detik)
  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      _akunSiswa = [
        {
          'nama': 'Ahmad Faizz',
          'email': 'ahmad@email.com',
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
          'tidakHadir': '22',
        },
      ];
    });
  }

  /// handler RefreshIndicator
  Future<void> _handleRefresh() async {
    await _loadData(); // muat ulang (atau panggil API)
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: _akunSiswa.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _akunSiswa.length,
                  itemBuilder: (context, index) {
                    final siswa = _akunSiswa[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                                    siswa['nama'] ?? '',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  Text(siswa['email'] ?? ''),
                                  const SizedBox(height: 4),
                                  Text('Kelas : ${siswa['kelas']}'),
                                  Text('TTL   : ${siswa['ttl']}'),
                                  Text('No. Absen : ${siswa['absen']}'),
                                  Text('No. HP Ortu : ${siswa['noOrtu']}'),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Tidak hadir: ${siswa['tidakHadir']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () async {
                                      final ok = await openWhatsApp(
                                        phone: siswa['noOrtu']!,
                                        message:
                                            'Halo Orang Tua dari ${siswa['nama']}, kami ingin menyampaikan informasi kehadiran.',
                                      );
                                      if (!ok && context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'WhatsApp tidak ditemukan di perangkat',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const FaIcon(FontAwesomeIcons.whatsapp,
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
      ),
    );
  }
}
