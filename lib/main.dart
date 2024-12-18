import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'model/routes/routes.dart';
import 'view/page_global/welcome.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/welcome', // Rute awal
      getPages: [
        GetPage(
          name: '/welcome',
          page: () => WelcomeScreen(),
        ),
        ...AppRoutes.routes, // Semua rute lain
      ],
      unknownRoute: GetPage(
        name: '/welcome',
        page: () => WelcomeScreen(), // Redirect jika rute tidak dikenali
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
