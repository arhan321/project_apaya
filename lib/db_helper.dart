import 'package:mysql1/mysql1.dart';

class DBHelper {
  static Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: '100.100.55.20', // Ganti dengan host database kamu
      port: 13306, // Port MySQL
      user: 'root', // Ganti dengan username database
      password: '123', // Ganti dengan password database
      db: 'db_login', // Ganti dengan nama database kamu
    );
    return await MySqlConnection.connect(settings);
  }
}
