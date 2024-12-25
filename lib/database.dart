import 'dart:async';
import 'package:mysql1/mysql1.dart';

Future database() async {
  var setting = ConnectionSettings(
    host: '10.0.2.2', 
    // host: 'localhost',
    port: 3306,
    user: 'admin',
    password: 'admin',
    db: 'stock_asset',
  );

  return await MySqlConnection.connect(setting);
}
