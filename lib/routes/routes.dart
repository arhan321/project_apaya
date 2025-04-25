import 'package:forum/view/page_admin/downloadexcel.dart';
import 'package:forum/view/page_admin/editprofileadmin.dart';
import 'package:forum/view/page_admin/rekapadmin.dart';
// import 'package:forum/view/page_siswa/editprofilesiswa.dart' as editProfile;
import 'package:forum/view/page_siswa/profile.dart' as profile;
import 'package:get/get.dart';
import 'package:forum/view/page_admin/catatanadmin.dart';
import 'package:forum/view/page_admin/detailabsenadmin.dart';
import 'package:forum/view/page_guru/detailabsenguru.dart';
import 'package:forum/view/page_admin/editabsenadmin.dart';
import 'package:forum/view/page_admin/tambahakunguru.dart';
import '../view/page_global/welcome.dart'; // Halaman Welcome
import '../view/page_global/login.dart'; // Halaman Login
import '../view/page_global/register.dart'; // Halaman Register
import '../view/page_global/forgetpassword.dart'; // Halaman Lupa Password
import '../view/page_global/newpassword.dart'; // Halaman Reset Password
import '../view/page_siswa/mainpage.dart'; // Halaman Utama Siswa
// import '../../view/page_siswa/kalkulator.dart'; // Halaman Kalkulator
import '../view/page_siswa/profile.dart'; // Halaman Profil Siswa
import '../view/page_siswa/listabsen.dart'; // Halaman Daftar Absen
import '../view/page_siswa/formabsen.dart'; // Halaman Form Absen
import '../view/page_siswa/viewdetail.dart'; // Halaman Detail Absen
import '../view/page_guru/profileguru.dart'; // Halaman Profil Guru
import '../view/page_guru/listabsensiswa.dart'; // Halaman Daftar Absen Siswa
import '../view/page_guru/editabsen.dart'; // Halaman Edit Absen
import '../view/page_guru/mainpage_guru.dart'; // Halaman Utama Guru
import '../view/page_guru/editprofileguru.dart';
import '../view/page_guru/rekapabsen.dart'; // Halaman Rekap Absen
import '../view/page_orangtua/mainpageortu.dart'; // Halaman Utama Orang Tua
import '../view/page_orangtua/listabsenortu.dart'; // Halaman Daftar Absen Orang Tua
import '../view/page_orangtua/detailabsenortu.dart'; // Halaman Detail Absen Orang Tua
import '../view/page_orangtua/cekcatatan.dart';
import '../view/page_guru/catatanguru.dart'; // Halaman Catatan Guru
import '../view/page_admin/mainpage.dart'; // Halaman Dashboard Admin
import '../view/page_admin/listaccount.dart'; // Impor halaman List Account
import '../view/page_admin/statusakunsiswa.dart'; //neww
import '../view/page_admin/listakunguru.dart'; // Impor halaman ListAkunGuru
import '../view/page_admin/editakunguru.dart'; // Impor halaman EditAkunGuru
import '../view/page_admin/listakunsiswa.dart';
import '../view/page_admin/listakunadmin.dart';
import '../view/page_admin/editakunsiswa.dart';
import '../view/page_admin/tambahakunsiswa.dart';
import '../view/page_admin/listakunortu.dart'; // Halaman List Akun Orang Tua
import '../view/page_admin/tambahakunortu.dart'; // Halaman Tambah Akun Orang Tua
import '../view/page_admin/editakunortu.dart';
import '../view/page_admin/editakunadmin.dart'; // Import halaman edit akun admin
import '../view/page_admin/tambahakunadmin.dart'; // Import halaman tambah akun admin
import '../view/page_admin/daftarkelas.dart'; // Import halaman Daftar Kelas
import '../view/page_admin/tambahkelas.dart';
import '../view/page_admin/editkelas.dart';
import '../view/page_admin/kelolaabsensi.dart';
import '../view/page_admin/listabsenadmin.dart';
import '../view/page_admin/profileadmin.dart'; // Import halaman Profile Admin
import '../view/page_admin/editprofileadmin.dart'
    as editProfileAdmin; // Import halaman Edit Profile Admin
import '../view/page_siswa/editprofilesiswa.dart';
import '../view/page_orangtua/profilortu.dart';
// import '../view/page_admin/laporan.dart';
// Import halaman RekapAdminPage
import '../view/page_admin/downloadpdf.dart'; // Import halaman DownloadPDFPage

import '../view/page_orangtua/editprofileortu.dart';
import '../view/page_guru/tambahabsen.dart'; // Import halaman TambahAbsenPage
import '../view/page_admin/downloadexcel.dart';
import '../view/page_guru/downloadexcelpage.dart';


class AppRoutes {
  // Daftar Konstanta Rute
  static const welcome = '/welcome'; // Rute Welcome
  static const login = '/login'; // Rute Login
  static const register = '/register'; // Rute Register
  static const forgotPassword = '/forget-password'; // Rute Lupa Password
  static const newPassword = '/new-password'; // Rute Reset Password
  static const mainPage = '/mainPage'; // Rute Halaman Utama Siswa
  static const mainPageGuru = '/mainPageGuru'; // Rute Halaman Utama Guru
  static const mainPageOrtu = '/mainPageOrtu'; // Rute Halaman Utama Orang Tua
  static const kalkulator = '/kalkulator'; // Rute Kalkulator
  static const profile = '/profile'; // Rute Profil
  static const listAbsen = '/listAbsen'; // Rute Daftar Absen
  static const formAbsen = '/formAbsen'; // Rute Form Absen
  static const viewDetail = '/viewDetail'; // Rute Detail Absen
  static const profileGuru = '/profileGuru'; // Rute Profil Guru
  static const listAbsenSiswa = '/listAbsenSiswa'; // Rute Daftar Absen Siswa
  static const editAbsen = '/editAbsen'; // Rute Edit Absen
  static const rekapAbsen = '/rekapAbsen'; // Rute Rekap Absen
  static const listAbsenOrtu = '/listAbsenOrtu'; // Rute Daftar Absen Orang Tua
  static const detailAbsenOrtu =
      '/detailAbsenOrtu'; // Rute Detail Absen Orang Tua
  static const catatanGuru = '/catatanGuru'; // Rute Catatan Guru
  static const cekCatatan = '/cekCatatan'; // Rute Catatan Harian Orang Tua
  static const adminDashboard = '/adminDashboard'; // Rute Dashboard Admin
  static const listAccount = '/listAccount'; // Rute untuk List Account
   static const statusAkunSiswa = '/statusAkunSiswa'; //neww
  static const listAkunGuru = '/listAkunGuru'; // Rute untuk List Akun Guru
  static const editAkunGuru = '/editAkunGuru'; // Rute untuk Edit Akun Guru
  static const tambahAkunGuru = '/tambahAkunGuru';
  static const editProfileGuru = '/editProfileGuru';
  static const listAkunSiswa = '/listAkunSiswa';
  static const editAkunSiswa = '/editAkunSiswa';
  static const tambahAkunSiswa = '/tambahAkunSiswa';
  static const listAkunOrtu = '/listAkunOrtu';
  static const tambahAkunOrtu = '/tambahAkunOrtu';
  static const editAkunOrtu = '/editAkunOrtu';
  static const editAkunAdmin = '/editAkunAdmin';
  static const tambahAkunAdmin = '/tambahAkunAdmin';
  static const listAkunAdmin = '/listAkunadmin'; // Rute Halaman List Akun Admin
  static const daftarKelas = '/daftarKelas';
  static const tambahKelas = '/tambahKelas';
  static const editKelas = '/editKelas';
  static const kelolaAbsensi = '/kelolaAbsensi';
  static const listAbsenAdmin = '/listAbsenAdmin';
  static const detailAbsenAdmin = '/detailAbsenAdmin';
  static const detailAbsenGuru = '/detailAbsenGuru';
  static const editAbsenAdmin = '/editAbsenAdmin';
  static const catatanAdmin = '/catatanAdmin';
  static const profileAdmin = '/profileAdmin'; // Tambahkan rute konstan
  static const editProfileAdmin =
      '/editProfileAdmin'; // Rute konstan untuk Edit Profile Admin
  static const editProfileSiswa = '/editProfileSiswa';
  static const editProfileOrtu = '/editProfileOrtu';
  static const profilOrtu = '/profilOrtu';
  static const rekapAdmin = '/rekapAdmin';
  static const laporan = '/laporan';
  static const downloadPDF = '/downloadPDF'; // Route untuk Download PDF
  static const tambahAbsen = '/tambahAbsen';

  static const downloadexcel = '/downloadexcel';
  static const donwloadexcelpage = '/downloadexcelpage';

  static List<GetPage> routes = [
    GetPage(
      name: welcome,
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: newPassword,
      page: () => NewPasswordScreen(),
    ),
    GetPage(
      name: mainPage,
      page: () => MainPage(), // Halaman Utama Siswa
    ),
    GetPage(
      name: mainPageGuru,
      page: () => MainPageGuru(), // Halaman Utama Guru
    ),
    GetPage(
      name: mainPageOrtu,
      page: () => MainPageOrtu(), // Halaman Utama Orang Tua
    ),
    GetPage(
      name: profile, // Nama rute
      page: () =>
          const ProfilePage(), // Langsung arahkan ke halaman ProfilePage
    ),
    GetPage(
      name: listAbsen,
      page: () {
        final int classId =
            Get.arguments['classId'] ?? 0; // Ambil classId dari arguments
        return ListAbsenPage(classId: classId);
      },
    ),
    GetPage(
      name: formAbsen,
      page: () => FormAbsenPage(
        classId: Get.arguments['classId'], // Ambil classId dari arguments
      ),
    ),
    GetPage(
      name: profileGuru,
      page: () => ProfileGuruPage(), // Profil Guru
    ),
    GetPage(
      name: viewDetail,
      page: () => ViewDetailPage(), // Detail Absen
    ),
    GetPage(
      name: listAbsenSiswa,
      page: () {
        final int classId = Get.arguments['classId'] ?? 0;
        return ListAbsenSiswaPage(classId: classId);
      },
    ),
    GetPage(
      name: editAbsen,
      page: () => EditAbsenPage(), // Edit Absen
    ),
    GetPage(
      name: rekapAbsen,
      page: () => RekapGuruPage(), // Rekap Absen
    ),
    GetPage(
      name: listAbsenOrtu,
      page: () {
        final int classId = Get.arguments?['classId'] ?? 0; // Default ke 0
        return ListAbsenOrtu(classId: classId);
      },
    ),
    GetPage(
      name: detailAbsenOrtu,
      page: () => DetailAbsenOrtu(), // Detail Absen Orang Tua
    ),
    GetPage(
      name: catatanGuru,
      page: () => CatatanGuruPage(), // Catatan Guru
    ),
    GetPage(
      name: cekCatatan,
      page: () => CekCatatanPage(), // Catatan Harian Orang Tua
    ),
    GetPage(
      name: adminDashboard,
      page: () => AdminDashboard(), // Dashboard Admin
    ),
    GetPage(
      name: listAccount,
      page: () => ListAccountPage(), // Rute ke halaman List Account
    ),
     GetPage(
      name: statusAkunSiswa,
      page: () => StatusAkunSiswa(), //neww
    ),
    GetPage(
      name: listAkunGuru,
      page: () => ListAkunGuru(), // Rute ke halaman List Akun Guru
    ),
    GetPage(
      name: editAkunGuru,
      page: () => EditAkunGuru(), // Rute ke halaman Edit Akun Guru
    ),
    GetPage(
      name: tambahAkunGuru,
      page: () => TambahAkunGuru(), // Halaman Tambah Akun Guru
    ),
    GetPage(
      name: listAkunSiswa,
      page: () => ListAkunSiswa(),
    ),
    GetPage(
      name: editAkunSiswa,
      page: () => EditAkunSiswa(),
    ),
    GetPage(
      name: tambahAkunSiswa,
      page: () => TambahAkunSiswa(),
    ),
    GetPage(
      name: listAkunOrtu,
      page: () => ListAkunOrtu(),
    ),
    GetPage(
      name: tambahAkunOrtu,
      page: () => TambahAkunOrtu(),
    ),
    GetPage(
      name: editAkunOrtu,
      page: () => EditAkunOrtu(),
    ),
    GetPage(
      name: listAkunAdmin,
      page: () => ListAkunAdminPage(), // Halaman List Akun Admin
    ),
    GetPage(
      name: editAkunAdmin,
      page: () => EditAkunAdminPage(),
    ),
    GetPage(
      name: tambahAkunAdmin,
      page: () => TambahAkunAdmin(),
    ),
    GetPage(
      name: daftarKelas,
      page: () => DaftarKelasPage(),
    ),
    GetPage(
      name: tambahKelas,
      page: () => TambahKelasPage(),
    ),
    GetPage(
      name: editKelas,
      page: () => EditKelasPage(),
    ),
    GetPage(
      name: kelolaAbsensi,
      page: () => KelolaAbsensiPage(),
    ),
    GetPage(
      name: listAbsenAdmin,
      page: () => ListAbsenAdminPage(),
    ),
    GetPage(name: detailAbsenGuru, page: () => DetailAbsenGuruPage()),
    GetPage(name: detailAbsenAdmin, page: () => DetailAbsenAdminPage()),
    GetPage(name: editAbsenAdmin, page: () => EditAbsenAdminPage()),
    GetPage(name: catatanAdmin, page: () => CatatanAdminPage()),
    GetPage(
      name: profileAdmin,
      page: () => ProfileAdminPage(),
    ),
    GetPage(
      name: editProfileAdmin,
      page: () => EditProfileAdminPage(),
    ),
    GetPage(
      name: editProfileGuru,
      page: () => EditProfileGuruPage(),
    ),
    GetPage(
      name: editProfileSiswa,
      page: () => EditProfileSiswaPage(),
    ),
    GetPage(
      name: editProfileOrtu,
      page: () => EditProfileOrtuPage(),
    ),
    GetPage(
      name: profilOrtu,
      page: () => ProfilortuPage(),
    ),
    GetPage(
      name: rekapAdmin,
      page: () => RekapAdminPage(),
    ),
    GetPage(
      name: tambahAbsen,
      page: () {
        // Since 'classId' is passed directly, we can just use it without casting
        final int passedClassId =
            Get.arguments ?? 0; // Default to 0 if it's null
        return TambahAbsenPage(classId: passedClassId);
      },
    ),
    GetPage(
      name: downloadPDF,
      page: () {
        // Ambil arguments yang dikirim saat navigasi ke halaman DownloadPDFPage
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return DownloadPDFPage(
          semester: args['semester'] ?? '',
          className: args['className'] ?? '',
          waliKelas: args['waliKelas'] ?? '',
          rekapData: args['rekapData'] ?? [],
        );
      },
    ),
    GetPage(
      name: downloadexcel,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return DownloadExcelPage(
          semester: args['semester'] ?? '',
          className: args['className'] ?? '',
          waliKelas: args['waliKelas'] ?? '',
          rekapData: args['rekapData'] ?? [],
        );
      },
    ),
    GetPage(
      name: donwloadexcelpage,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return downloadexcelguru(
          semester: args['semester'] ?? '',
          className: args['className'] ?? '',
          waliKelas: args['waliKelas'] ?? '',
          rekapData: args['rekapData'] ?? [],
        );
      },
    ),
  ];
}
