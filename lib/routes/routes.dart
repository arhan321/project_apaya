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
import '../page_guru/profileguru.dart'; // Halaman Profil Siswa
import '../page_guru/listabsensiswa.dart'; // Halaman Daftar Absen Siswa
import '../page_guru/editabsen.dart';
import '../page_guru/mainpage_guru.dart'; // Halaman Utama Guru
import '../page_guru/rekapabsen.dart'; // Halaman Rekap Absen
import '../page_orangtua/mainpageortu.dart'; // Halaman Utama Orang Tua (MainPageOrtu)
import '../page_orangtua/listabsenortu.dart'; // Halaman Daftar Absen Orang Tua
import '../page_orangtua/detailabsenortu.dart'; // Halaman Detail Absen Orang Tua
import '../page_guru/catatanguru.dart'; // Halaman Catatan Guru

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
  static const profileGuru = '/profileGuru'; // Rute Profile Guru
  static const listAbsenSiswa = '/listAbsenSiswa'; // Rute Daftar Absen Siswa
  static const editAbsen = '/editAbsen'; // Rute untuk Edit Absen
  static const rekapAbsen = '/rekapAbsen'; // Rute Rekap Absen (NEW)
  static const listAbsenOrtu = '/listAbsenOrtu';// Rute Daftar Absen untuk Orang Tua
  static const detailAbsenOrtu = '/detailAbsenOrtu'; // Rute Detail Absen Orang Tua
  static const catatanGuru = '/catatanGuru'; // Rute Catatan Guru

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
      page: () => MainPage(userName: ''), // Rute Halaman Siswa
    ),
    GetPage(
      name: mainPageGuru,
      page: () => MainPageGuru(), // Rute Halaman Guru
    ),
    GetPage(
      name: mainPageOrtu,
      page: () => MainPageOrtu(userName: 'Orang Tua'), // Rute Halaman Utama Orang Tua
    ),
    GetPage(
      name: kalkulator,
      page: () => KalkulatorPage(userName: 'Guest'), // Rute Kalkulator
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(), // Rute Profil
    ),
    GetPage(
      name: listAbsen,
      page: () => ListAbsenPage(className: 'Default Class'), // Rute Daftar Absen
    ),
    GetPage(
      name: formAbsen,
      page: () => FormAbsenPage(), // Rute Form Absen
    ),
    GetPage(
      name: profileGuru,
      page: () => ProfileGuruPage(kelas: '',), // Rute Profile Guru
    ),
    GetPage(
      name: viewDetail,
      page: () => ViewDetailPage(), // Rute Detail Absen
    ),
    GetPage(
      name: listAbsenSiswa,
      page: () => ListAbsenSiswaPage(className: 'Kelas 6A'), // Rute Daftar Absen Siswa
    ),
    GetPage(
      name: editAbsen,
      page: () => EditAbsenPage(),
    ),
    GetPage(
      name: rekapAbsen,
      page: () => RekapAbsenPage(), // Rute Halaman Rekap Absen
    ),
    GetPage(
      name: listAbsenOrtu,
      page: () => ListAbsenOrtu(), // Tanpa parameter
    ),
    GetPage(
      name: detailAbsenOrtu,
      page: () => DetailAbsenOrtu(),
    ),
    GetPage(
      name: catatanGuru,
      page: () => CatatanGuruPage(), // Rute Halaman Catatan Guru
    ),
  ];
}
