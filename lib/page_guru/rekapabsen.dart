import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'downloadrekappage.dart'; // Import halaman DownloadRekapPage

class RekapAbsenPage extends StatelessWidget {
  const RekapAbsenPage({Key? key}) : super(key: key);

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
          'Rekap Absen',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
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
        child: ListView(
          children: [
            _buildCard(
              className: "Kelas 6A",
              waliKelas: "Tatang Sutarman",
              context: context, // Pass context
            ),
            SizedBox(height: 16),
            _buildCard(
              className: "Kelas 5B",
              waliKelas: "Siti Fatimah",
              context: context, // Pass context
            ),
            SizedBox(height: 16),
            _buildCard(
              className: "Kelas 4C",
              waliKelas: "Ahmad Fauzan",
              context: context, // Pass context
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the card for each class
  Widget _buildCard({required String className, required String waliKelas, required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            className,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Wali Kelas: $waliKelas",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDownloadButton("Rekap Semester 1", context, className, waliKelas),
              SizedBox(height: 8),
              _buildDownloadButton("Rekap Semester 2", context, className, waliKelas),
            ],
          ),
        ],
      ),
    );
  }

  // Function to create download button
  Widget _buildDownloadButton(String label, BuildContext context, String className, String waliKelas) {
    return ElevatedButton.icon(
      onPressed: () {
        // Navigasi ke halaman DownloadRekapPage dengan passing argument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DownloadRekapPage(
              className: className,
              waliKelas: waliKelas, semester: '',
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(Icons.download, color: Colors.white),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
