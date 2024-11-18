import 'package:get/get.dart';
import '../welcome.dart'; 
import '../login.dart';
import '../register.dart';
import '../mainpage.dart';
import '../kalkulator.dart';
import '../forgetpassword.dart';
import '../newpassword.dart';
import '../profile.dart'; 

class AppRoutes {
  static const welcome = '/welcome'; // Rute untuk WelcomeScreen
  static const login = '/login';
  static const register = '/register';
  static const mainPage = '/mainPage';
  static const kalkulator = '/kalkulator';
  static const forgotPassword = '/forget-password';
  static const newPassword = '/new-password';
  static const profile = '/profile'; // Rute untuk ProfilePage

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
      name: mainPage,
      page: () => MainPage(userName: ''),
    ),
    GetPage(
      name: kalkulator,
      page: () => KalkulatorPage(userName: 'Guest'),
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
    name: profile,
    page: () => ProfilePage(),
    ),
  ];
}
