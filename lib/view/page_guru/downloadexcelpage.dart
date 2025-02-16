import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart'; // <--- Perlu untuk Android 13+
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class downloadexcelguru extends StatelessWidget {
  final String className;
  final String waliKelas;
  final String semester; // "1" untuk semester 1, "2" untuk semester 2
  final List<Map<String, dynamic>> rekapData;
  final String schoolName = "SDN Rancagong 1"; // Nama sekolah

  const downloadexcelguru({
    Key? key,
    required this.className,
    required this.waliKelas,
    required this.semester,
    required this.rekapData,
  }) : super(key: key);

  /// Fungsi untuk meng-agregasi data per siswa
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

  /// Fungsi utama untuk membuat dan mengunduh file Excel (.xlsx)
  Future<void> _downloadExcel(BuildContext context) async {
    try {
      final aggregated = _aggregateData();

      // 1) Buat workbook Excel dan sheet default
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // 2) Baris-baris header informasi
      sheetObject.appendRow(["Rekap Absen $schoolName"]);
      sheetObject.appendRow(["Kelas: $className - Semester: $semester"]);
      sheetObject.appendRow(["Wali Kelas: $waliKelas"]);
      // Baris kosong pemisah
      sheetObject.appendRow([]);

      // 3) Definisikan style header untuk tabel
      var headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: "#EEEEEE",
        horizontalAlign: HorizontalAlign.Center,
      );

      // 4) Buat header kolom rekap data
      List<String> headers = ["Nama", "Hadir", "Tidak Hadir", "Izin", "Sakit"];
      int headerRowIndex = sheetObject.maxRows;
      int colIndex = 0;
      for (var header in headers) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex, rowIndex: headerRowIndex));
        cell.value = header;
        cell.cellStyle = headerStyle;
        colIndex++;
      }

      // 5) Tulis data rekap ke Excel
      int rowIndex = headerRowIndex + 1;
      aggregated.forEach((student, counts) {
        int colIndex = 0;
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .value = student;
        colIndex++;
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .value = counts['Hadir'].toString();
        colIndex++;
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .value = counts['Tidak Hadir'].toString();
        colIndex++;
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .value = counts['Izin'].toString();
        colIndex++;
        sheetObject
            .cell(CellIndex.indexByColumnRow(
                columnIndex: colIndex, rowIndex: rowIndex))
            .value = counts['Sakit'].toString();
        rowIndex++;
      });

      // 6) Encode workbook menjadi List<int>, lalu ubah ke Uint8List
      List<int>? rawBytes = excel.encode();
      if (rawBytes == null) {
        throw 'Gagal meng-encode file Excel.';
      }
      Uint8List fileBytes = Uint8List.fromList(rawBytes);

      // 7) Cek apakah Web atau Mobile
      if (kIsWeb) {
        // Tidak didukung di web
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Fitur download Excel tidak tersedia di web"),
          ),
        );
        return;
      }

      // 8) Jika Android, cek versi
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt ?? 0;
        debugPrint("=== SDK Version: $sdkInt ===");

        if (sdkInt < 33) {
          // Android < 13 => butuh permission WRITE_EXTERNAL_STORAGE
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            debugPrint("Storage permission denied.");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Storage Permission Denied!")),
            );
            return;
          }

          // Simpan langsung ke folder Download
          await _saveExcelToDownloadFolder(fileBytes, context);
        } else {
          // Android 13+ => Pakai file picker
          await _saveExcelWithFilePicker(fileBytes, context);
        }
      } else {
        // 9) iOS atau platform lain => Simpan ke Documents directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/rekap_absen_$className.xlsx';
        final file = File(filePath);

        await file.writeAsBytes(fileBytes);
        debugPrint("Excel berhasil disimpan di iOS path: $filePath");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Excel berhasil disimpan di $filePath (iOS)")),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error saat mengunduh Excel: $e');
      debugPrint('StackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh Excel: $e")),
      );
    }
  }

  /// (Android < 13) Simpan file .xlsx ke folder Download di dalam getExternalStorageDirectory()
  Future<void> _saveExcelToDownloadFolder(
    Uint8List fileBytes,
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
      }

      final filePath =
          '${downloadDirectory.path}/rekap_absen_${className}_semester_$semester.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);

      debugPrint("File Excel disimpan di: $filePath");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Excel berhasil diunduh ke: $filePath")),
      );
    } catch (e, stackTrace) {
      debugPrint('=== ERROR Menyimpan file Excel ke DownloadFolder ===');
      debugPrint('Pesan Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menulis file Excel: $e")),
      );
    }
  }

  /// (Android 13+ dan platform lain) Simpan file .xlsx dengan file_picker
  Future<void> _saveExcelWithFilePicker(
    Uint8List fileBytes,
    BuildContext context,
  ) async {
    try {
      // Gunakan file_picker agar user bisa memilih lokasi & nama file
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Pilih lokasi untuk menyimpan Excel',
        fileName: 'rekap_absen_${className}_semester_$semester.xlsx',
        bytes: fileBytes, // WAJIB: agar plugin menulis file di Android/iOS
      );

      if (result == null) {
        // User membatalkan
        debugPrint("User membatalkan pemilihan file.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Penyimpanan dibatalkan")),
        );
        return;
      }

      // Di Android/iOS, plugin sudah menulis file.
      // Tampilkan info ke user
      debugPrint("Excel berhasil disimpan di $result");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Excel berhasil disimpan di $result")),
      );
    } catch (e, stackTrace) {
      debugPrint('=== ERROR Menyimpan file Excel dengan FilePicker ===');
      debugPrint('Pesan Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan Excel: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Preview data yang sudah diaggregasi
    final aggregated = _aggregateData();
    final List<Map<String, dynamic>> previewData = aggregated.entries
        .map(
          (entry) => {
            'nama': entry.key,
            'Hadir': entry.value['Hadir'],
            'Tidak Hadir': entry.value['Tidak Hadir'],
            'Izin': entry.value['Izin'],
            'Sakit': entry.value['Sakit'],
          },
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rekap Absen Excel',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _downloadExcel(context),
        label: const Text("Download Excel"),
        icon: const Icon(Icons.download),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rekap Absen $schoolName\n$className - Semester $semester\nWali Kelas: $waliKelas',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: previewData.length,
                itemBuilder: (context, index) {
                  final item = previewData[index];
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
                          item['nama'] ?? '-',
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
                              'Hadir: ${item['Hadir']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Tidak Hadir: ${item['Tidak Hadir']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Izin: ${item['Izin']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Sakit: ${item['Sakit']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
