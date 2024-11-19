import 'package:flutter/material.dart';
import 'page_global/welcome.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/welcome', // Rute awal diubah menjadi welcome
      getPages: [
        GetPage(
          name: '/welcome',
          page: () => WelcomeScreen(),
        ),
        ...AppRoutes.routes, // Tambahkan rute lain yang sudah ada
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
