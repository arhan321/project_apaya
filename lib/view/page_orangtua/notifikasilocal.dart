// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin
//       _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   // Inisialisasi notifikasi
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: IOSInitializationSettings(),
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   // Menampilkan notifikasi lokal
//   static Future<void> showNotification(String title, String body) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'your_channel_id', // Channel ID
//       'your_channel_name', // Channel name
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0, // ID notifikasi
//       title, // Judul
//       body, // Isi pesan
//       platformDetails,
//       payload: 'Custom_Sound', // Bisa ditambahkan payload sesuai kebutuhan
//     );
//   }
// }
