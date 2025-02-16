import 'dart:io';
import 'dart:typed_data'; // <-- Pastikan import untuk Uint8List
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart'; // <-- Untuk FilePicker Android 13+
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// 'printing' tidak dipakai di implementasi ini, boleh dihapus jika tak diperlukan
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadRekapPage extends StatelessWidget {
  final String className;
  final String waliKelas;
  final String semester; // "1" atau "2"
  final List<Map<String, dynamic>> rekapData;
  final String schoolName = "SDN Rancagong 1"; // Nama sekolah

  const DownloadRekapPage({
    Key? key,
    required this.className,
    required this.waliKelas,
    required this.semester,
    required this.rekapData,
  }) : super(key: key);

  /// Fungsi untuk memuat font dari assets
  Future<pw.Font> _loadFont() async {
    try {
      final fontData = await rootBundle.load('assets/fonts/Poppins-Light.ttf');
      return pw.Font.ttf(fontData);
    } catch (e) {
      throw 'Gagal memuat font: $e';
    }
  }

  /// Fungsi untuk meng-agregasi data per siswa dari [rekapData] mentah.
  /// Mengembalikan Map dengan key: nama siswa, value: Map kategori absen.
  Map<String, Map<String, int>> _aggregateData() {
    final Map<String, Map<String, int>> aggregated = {};

    for (var item in rekapData) {
      final String? tanggalStr = item['tanggal_absen'];
      if (tanggalStr == null || tanggalStr.isEmpty) continue;

      DateTime tanggal;
      try {
        tanggal = DateTime.parse(tanggalStr);
      } catch (e) {
        continue; // Lewati record jika parsing gagal
      }

      // Cek rentang semester
      final int month = tanggal.month;
      bool inSemester = false;
      if (semester == "1" && month >= 1 && month <= 6) {
        inSemester = true;
      } else if (semester == "2" && month >= 7 && month <= 12) {
        inSemester = true;
      }
      if (!inSemester) continue;

      final String studentName = item['nama'] ?? '-';

      if (!aggregated.containsKey(studentName)) {
        aggregated[studentName] = {
          'Hadir': 0,
          'Tidak Hadir': 0,
          'Izin': 0,
          'Sakit': 0,
        };
      }

      final String status = (item['keterangan'] ?? '').toString().toLowerCase();
      if (status == 'hadir') {
        aggregated[studentName]!['Hadir'] =
            aggregated[studentName]!['Hadir']! + 1;
      } else if (status == 'tidak hadir') {
        aggregated[studentName]!['Tidak Hadir'] =
            aggregated[studentName]!['Tidak Hadir']! + 1;
      } else if (status == 'izin') {
        aggregated[studentName]!['Izin'] =
            aggregated[studentName]!['Izin']! + 1;
      } else if (status == 'sakit') {
        aggregated[studentName]!['Sakit'] =
            aggregated[studentName]!['Sakit']! + 1;
      }
    }
    return aggregated;
  }

  /// Fungsi utama untuk membuat dan mengunduh file PDF.
  Future<void> _downloadPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();
      final font = await _loadFont();

      // Agregasi data per siswa
      final aggregated = _aggregateData();

      // Siapkan data tabel
      final List<List<String>> tableData = [];
      aggregated.forEach((student, counts) {
        tableData.add([
          student,
          counts['Hadir'].toString(),
          counts['Tidak Hadir'].toString(),
          counts['Izin'].toString(),
          counts['Sakit'].toString(),
        ]);
      });

      // Buat halaman PDF (header + tabel rekap)
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Rekap Absen $schoolName',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: font,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  '$className - Semester $semester',
                  style: pw.TextStyle(fontSize: 18, font: font),
                ),
                pw.Text(
                  'Wali Kelas: $waliKelas',
                  style: pw.TextStyle(fontSize: 16, font: font),
                ),
                pw.Divider(height: 20, thickness: 2),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    font: font,
                  ),
                  cellStyle: pw.TextStyle(fontSize: 12, font: font),
                  headers: ['Nama', 'Hadir', 'Tidak Hadir', 'Izin', 'Sakit'],
                  data: tableData,
                  border:
                      pw.TableBorder.all(color: PdfColor.fromInt(0xffCCCCCC)),
                  cellAlignment: pw.Alignment.centerLeft,
                  headerDecoration:
                      pw.BoxDecoration(color: PdfColor.fromInt(0xffEEEEEE)),
                  cellPadding: const pw.EdgeInsets.all(8),
                ),
              ],
            );
          },
        ),
      );

      // Simpan PDF ke dalam byte array (Uint8List)
      final bytes = await pdf.save();

      // Cek platform: Web atau Mobile
      if (kIsWeb) {
        // Web belum didukung
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fitur download PDF tidak tersedia di web"),
          ),
        );
        return;
      }

      // Jika Android/iOS
      if (Platform.isAndroid) {
        // Cek versi Android
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt ?? 0;
        debugPrint("=== SDK Version: $sdkInt ===");

        if (sdkInt < 33) {
          // Android < 13 => perlu permission WRITE_EXTERNAL_STORAGE
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            debugPrint("Storage permission denied.");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Storage Permission Denied!")),
            );
            return;
          }

          // Simpan manual ke folder Download
          await _savePDFToDownloadFolder(bytes, context);
        } else {
          // Android 13+ => gunakan FilePicker untuk simpan
          await _savePdfWithFilePicker(bytes, context);
        }
      } else {
        // iOS atau platform lain
        final directory = await getApplicationDocumentsDirectory();
        final filePath =
            '${directory.path}/rekap_absen_${className}_semester_$semester.pdf';
        final file = File(filePath);

        await file.writeAsBytes(bytes);
        debugPrint("File PDF berhasil disimpan: $filePath");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF berhasil disimpan di: $filePath")),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error saat mengunduh PDF: $e');
      debugPrint('StackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh PDF: $e")),
      );
    }
  }

  /// (Android < 13) Simpan PDF ke folder Download
  Future<void> _savePDFToDownloadFolder(
    Uint8List bytes,
    BuildContext context,
  ) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw 'Directory path not found.';
      }

      final downloadDirectory = Directory('${directory.path}/Download');
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create();
        debugPrint("Folder Download dibuat: ${downloadDirectory.path}");
      }

      final filePath =
          '${downloadDirectory.path}/rekap_absen_${className}_semester_$semester.pdf';
      final file = File(filePath);

      await file.writeAsBytes(bytes);
      debugPrint("File PDF disimpan di: $filePath");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF berhasil diunduh ke: $filePath")),
      );
    } catch (e, stackTrace) {
      debugPrint('=== ERROR Menyimpan file PDF ke DownloadFolder ===');
      debugPrint('Pesan Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menulis file PDF: $e")),
      );
    }
  }

  /// (Android 13+ dan platform lain) Simpan PDF dengan FilePicker
  Future<void> _savePdfWithFilePicker(
    Uint8List bytes,
    BuildContext context,
  ) async {
    try {
      // Minta user pilih lokasi & nama file
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Pilih lokasi untuk menyimpan PDF',
        fileName: 'rekap_absen_${className}_semester_$semester.pdf',
        bytes: bytes, // WAJIB: Agar file_picker menulis file di Android/iOS
      );

      if (result == null) {
        // User membatalkan
        debugPrint("User membatalkan pemilihan file.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Penyimpanan dibatalkan")),
        );
        return;
      }

      // Plugin file_picker sudah menuliskan file di Android/iOS
      debugPrint("PDF berhasil disimpan di $result");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF berhasil disimpan di $result")),
      );
    } catch (e, stackTrace) {
      debugPrint('=== ERROR Menyimpan file PDF dengan FilePicker ===');
      debugPrint('Pesan Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan PDF: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hasil agregasi untuk preview data; tiap siswa muncul satu kali
    final aggregated = _aggregateData();
    final List<Map<String, dynamic>> previewData = aggregated.entries
        .map((entry) => {
              'nama': entry.key,
              'Hadir': entry.value['Hadir'],
              'Tidak Hadir': entry.value['Tidak Hadir'],
              'Izin': entry.value['Izin'],
              'Sakit': entry.value['Sakit'],
            })
        .toList();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Rekap Absen PDF',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _downloadPDF(context),
        label: const Text("Download PDF"),
        icon: const Icon(Icons.download),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: previewData.length,
                itemBuilder: (context, index) {
                  final item = previewData[index];
                  return _buildPreviewItem(
                    name: item['nama'] ?? '-',
                    hadir: item['Hadir']?.toString() ?? '0',
                    tidakHadir: item['Tidak Hadir']?.toString() ?? '0',
                    izin: item['Izin']?.toString() ?? '0',
                    sakit: item['Sakit']?.toString() ?? '0',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header menampilkan informasi rekap absen
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Rekap Absen $schoolName\n$className - Semester $semester\nWali Kelas: $waliKelas',
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Preview data aggregated per siswa
  Widget _buildPreviewItem({
    required String name,
    required String hadir,
    required String tidakHadir,
    required String izin,
    required String sakit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Hadir: $hadir',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              Text('Tidak Hadir: $tidakHadir',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              Text('Izin: $izin',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
              Text('Sakit: $sakit',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
