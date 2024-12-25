// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart'; // Untuk format tanggal

// class EditProfileAdminPage extends StatefulWidget {
//   @override
//   _EditProfileAdminPageState createState() => _EditProfileAdminPageState();
// }

// class _EditProfileAdminPageState extends State<EditProfileAdminPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController roleController =
//       TextEditingController(text: 'Administrator');
//   final TextEditingController birthDateController =
//       TextEditingController(); // Tambahkan controller untuk tanggal lahir

//   File? _imageFile;
//   final picker = ImagePicker();

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (selectedDate != null) {
//       setState(() {
//         birthDateController.text =
//             DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }

//   void _saveProfile() {
//     Get.snackbar(
//       'Success',
//       'Profile berhasil diperbarui!',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.greenAccent,
//       colorText: Colors.white,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueAccent, Colors.lightBlueAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: Text(
//           'Edit Profile Admin',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent, Colors.lightBlueAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 60,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!)
//                           : AssetImage('assets/placeholder.jpg')
//                               as ImageProvider,
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: _pickImage,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.blueAccent,
//                           radius: 20,
//                           child: Icon(Icons.camera_alt, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30),
//               _buildInputLabel('Name'),
//               _buildInputField(
//                   controller: nameController, hintText: 'Enter name'),
//               SizedBox(height: 20),
//               _buildInputLabel('Email'),
//               _buildInputField(
//                   controller: emailController, hintText: 'Enter email'),
//               SizedBox(height: 20),
//               _buildInputLabel('Role'),
//               _buildInputField(
//                   controller: roleController, hintText: 'Role', enabled: false),
//               SizedBox(height: 20),
//               _buildInputLabel('Tanggal Lahir'),
//               _buildDateField(context), // Field untuk tanggal lahir
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Simpan Perubahan',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputLabel(String text) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: GoogleFonts.poppins(
//           fontSize: 14,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String hintText,
//     bool enabled = true,
//   }) {
//     return TextFormField(
//       controller: controller,
//       enabled: enabled,
//       style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
//         filled: true,
//         fillColor: Colors.white,
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.white, width: 1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _pickDate(context),
//       child: AbsorbPointer(
//         child: TextFormField(
//           controller: birthDateController,
//           decoration: InputDecoration(
//             hintText: 'Pilih tanggal lahir',
//             hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
//             filled: true,
//             fillColor: Colors.white,
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.white, width: 1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
