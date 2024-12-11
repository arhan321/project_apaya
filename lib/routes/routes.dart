import 'package:forum/page_admin/tambahakunguru.dart';
import 'package:get/get.dart';
import '../page_global/welcome.dart'; // Halaman Welcome
import '../page_global/login.dart'; // Halaman Login
import '../page_global/register.dart'; // Halaman Register
import '../page_global/forgetpassword.dart'; // Halaman Lupa Password
import '../page_global/newpassword.dart'; // Halaman Reset Password
import '../page_siswa/mainpage.dart'; // Halaman Utama Siswa
import '../page_siswa/kalkulator.dart'; // Halaman Kalkulator
import '../page_siswa/profile.dart'; // Halaman Profil Siswa
import '../page_siswa/listabsen.dart'; // Halaman Daftar Absen
import '../page_siswa/formabsen.dart'; // Halaman Form Absen
import '../page_siswa/viewdetail.dart'; // Halaman Detail Absen
import '../page_guru/profileguru.dart'; // Halaman Profil Guru
import '../page_guru/listabsensiswa.dart'; // Halaman Daftar Absen Siswa
import '../page_guru/editabsen.dart'; // Halaman Edit Absen
import '../page_guru/mainpage_guru.dart'; // Halaman Utama Guru
import '../page_guru/rekapabsen.dart'; // Halaman Rekap Absen
import '../page_orangtua/mainpageortu.dart'; // Halaman Utama Orang Tua
import '../page_orangtua/listabsenortu.dart'; // Halaman Daftar Absen Orang Tua
import '../page_orangtua/detailabsenortu.dart'; // Halaman Detail Absen Orang Tua
import '../page_guru/catatanguru.dart'; // Halaman Catatan Guru
import '../page_admin/dashboard.dart'; // Halaman Dashboard Admin
import '../page_admin/listaccount.dart'; // Impor halaman List Account
import '../page_admin/listakunguru.dart'; // Impor halaman ListAkunGuru
import '../page_admin/editakunguru.dart'; // Impor halaman EditAkunGuru
import '../page_admin/listakunsiswa.dart';
import '../page_admin/editakunsiswa.dart';
import '../page_admin/tambahakunsiswa.dart';
import '../page_admin/listakunortu.dart'; // Halaman List Akun Orang Tua
import '../page_admin/tambahakunortu.dart'; // Halaman Tambah Akun Orang Tua
import '../page_admin/editakunortu.dart';
// import '../page_admin/tambahakunsiswa.dart';
// import '../page_admin/manage_users.dart'; // Halaman Kelola Pengguna (Admin)
// import '../page_admin/manage_absences.dart'; // Halaman Kelola Absensi (Admin)
// import '../page_admin/reports.dart'; // Halaman Laporan (Admin)

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
  static const detailAbsenOrtu = '/detailAbsenOrtu'; // Rute Detail Absen Orang Tua
  static const catatanGuru = '/catatanGuru'; // Rute Catatan Guru
  static const adminDashboard = '/adminDashboard'; // Rute Dashboard Admin
  static const listAccount = '/listAccount'; // Rute untuk List Account
  static const listAkunGuru = '/listAkunGuru'; // Rute untuk List Akun Guru
  static const editAkunGuru = '/editAkunGuru'; // Rute untuk Edit Akun Guru
  static const tambahAkunGuru = '/tambahAkunGuru';
  static const listAkunSiswa = '/listAkunSiswa';
  static const editAkunSiswa = '/editAkunSiswa';
  static const tambahAkunSiswa = '/tambahAkunSiswa';
  static const listAkunOrtu = '/listAkunOrtu';
  static const tambahAkunOrtu = '/tambahAkunOrtu';
  static const editAkunOrtu = '/editAkunOrtu';
  // static const tambahAkunsiswa = '/tambahAkunSiswa';

  // // Tambahan Rute untuk Admin
  // static const adminDashboard = '/adminDashboard'; // Rute Dashboard Admin
  // static const manageUsers = '/manageUsers'; // Rute Kelola Pengguna
  // static const manageAbsences = '/manageAbsences'; // Rute Kelola Absensi
  // static const reports = '/reports'; // Rute Laporan

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
      page: () => MainPage(userName: ''), // Halaman Utama Siswa
    ),
    GetPage(
      name: mainPageGuru,
      page: () => MainPageGuru(), // Halaman Utama Guru
    ),
    GetPage(
      name: mainPageOrtu,
      page: () => MainPageOrtu(userName: 'Orang Tua'), // Halaman Utama Orang Tua
    ),
    GetPage(
      name: kalkulator,
      page: () => KalkulatorPage(userName: 'Guest'), // Kalkulator
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(), // Profil Siswa
    ),
    GetPage(
      name: listAbsen,
      page: () => ListAbsenPage(className: 'Default Class'), // Daftar Absen
    ),
    GetPage(
      name: formAbsen,
      page: () => FormAbsenPage(), // Form Absen
    ),
    GetPage(
      name: profileGuru,
      page: () => ProfileGuruPage(kelas: ''), // Profil Guru
    ),
    GetPage(
      name: viewDetail,
      page: () => ViewDetailPage(), // Detail Absen
    ),
    GetPage(
      name: listAbsenSiswa,
      page: () => ListAbsenSiswaPage(className: 'Kelas 6A'), // Daftar Absen Siswa
    ),
    GetPage(
      name: editAbsen,
      page: () => EditAbsenPage(), // Edit Absen
    ),
    GetPage(
      name: rekapAbsen,
      page: () => RekapAbsenPage(), // Rekap Absen
    ),
    GetPage(
      name: listAbsenOrtu,
      page: () => ListAbsenOrtu(), // Daftar Absen Orang Tua
    ),
    GetPage(
      name: detailAbsenOrtu,
      page: () => DetailAbsenOrtu(), // Detail Absen Orang Tua
    ),
    GetPage(
      name: catatanGuru,
      page: () => CatatanGuruPage(), // Catatan Guru
    ),
    // Tambahan Rute untuk Admin
    GetPage(
      name: adminDashboard,
      page: () => AdminDashboard(), // Dashboard Admin
    ),
     GetPage(
      name: listAccount,
      page: () => ListAccountPage(), // Rute ke halaman List Account
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
    // Rute untuk Tambah Akun Orang Tua
    GetPage(
      name: tambahAkunOrtu,
      page: () => TambahAkunOrtu(),
    ),
      GetPage(
      name: editAkunOrtu,
      page: () => EditAkunOrtu(),
    ),
    //   GetPage(
    //   name: tambahAkunSiswa,
    //   page: () => TambahAkunSiswa(), // Halaman Tambah Akun Guru
    // )
    // GetPage(
    //   name: manageUsers,
    //   page: () => ManageUsersPage(), // Kelola Pengguna
    // ),
    // GetPage(
    //   name: manageAbsences,
    //   page: () => ManageAbsencesPage(), // Kelola Absensi
    // ),
    // GetPage(
    //   name: reports,
    //   page: () => ReportsPage(), // Laporan
    // ),
  ];
}
