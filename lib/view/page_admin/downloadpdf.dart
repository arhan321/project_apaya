import 'dart:io';
import 'dart:typed_data'; // Import this to use Uint8List
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPDFPage extends StatelessWidget {
  final String className;
  final String waliKelas;
  final String semester;
  final String schoolName = "SDN Rancagong 1";

  const DownloadPDFPage({
    Key? key,
    required this.className,
    required this.waliKelas,
    required this.semester,
  }) : super(key: key);

  Future<pw.Font> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/Poppins-Light.ttf');
    return pw.Font.ttf(fontData);
  }

  Future<void> _requestPermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw 'Permission denied';
    }
  }

  // Fungsi untuk membuat dan mengunduh PDF
  Future<void> _downloadPDF(BuildContext context) async {
    final pdf = pw.Document();
    final font = await _loadFont();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Rekap Absen $schoolName',
                  style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      font: font)),
              pw.SizedBox(height: 8),
              pw.Text('$className - Semester $semester',
                  style: pw.TextStyle(fontSize: 18, font: font)),
              pw.Text('Wali Kelas: $waliKelas',
                  style: pw.TextStyle(fontSize: 16, font: font)),
              pw.Divider(height: 20, thickness: 2),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold, font: font),
                cellStyle: pw.TextStyle(fontSize: 12, font: font),
                headers: ['Nama', 'Hadir', 'Tidak Hadir', 'Izin', 'Sakit'],
                data: [
                  ['Randi Praditiya', '20', '2', '1', '1'],
                  ['Putra Dewantara', '22', '0', '1', '0'],
                  ['Adi Santoso', '18', '3', '2', '1'],
                  ['Wahyu Kurniawan', '25', '0', '0', '0'],
                ],
                border: pw.TableBorder.all(color: PdfColor.fromInt(0xffCCCCCC)),
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

    try {
      // Meminta izin menulis ke penyimpanan
      await _requestPermission();

      final bytes = await pdf.save();

      // Jika platform adalah Web, fitur sharePdf tidak tersedia.
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Fitur download PDF tidak tersedia di web")),
        );
      } else {
        // Mendapatkan direktori Download pada perangkat Android
        final directory = await getExternalStorageDirectory();

        if (directory == null) {
          throw 'Directory path not found';
        }

        // Mengarahkan file untuk disimpan di folder Download
        final downloadDirectory = Directory('${directory.path}/Download');
        if (!await downloadDirectory.exists()) {
          // Membuat folder Download jika tidak ada
          await downloadDirectory.create();
        }

        // Membuat path file untuk disimpan di folder Download
        final filePath =
            '${downloadDirectory.path}/rekap_absen_${className}_semester_$semester.pdf';

        // Menyimpan file PDF ke folder Download
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        // Log untuk melihat path file yang disimpan
        debugPrint("File disimpan di: $filePath");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF berhasil diunduh ke: $filePath")),
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

  @override
  Widget build(BuildContext context) {
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
              child: ListView(
                children: [
                  _buildRekapItem(
                    name: 'Randi Praditiya',
                    hadir: 20,
                    tidakHadir: 2,
                    izin: 1,
                    sakit: 1,
                  ),
                  _buildRekapItem(
                    name: 'Putra Dewantara',
                    hadir: 22,
                    tidakHadir: 0,
                    izin: 1,
                    sakit: 0,
                  ),
                  _buildRekapItem(
                    name: 'Adi Santoso',
                    hadir: 18,
                    tidakHadir: 3,
                    izin: 2,
                    sakit: 1,
                  ),
                  _buildRekapItem(
                    name: 'Wahyu Kurniawan',
                    hadir: 25,
                    tidakHadir: 0,
                    izin: 0,
                    sakit: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildRekapItem({
    required String name,
    required int hadir,
    required int tidakHadir,
    required int izin,
    required int sakit,
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
              Text(
                'Hadir: $hadir',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
              Text(
                'Tidak Hadir: $tidakHadir',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
              Text(
                'Izin: $izin',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
              Text(
                'Sakit: $sakit',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
