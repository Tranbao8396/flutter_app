import 'dart:async';
import 'package:mysql1/mysql1.dart';

Future database() async {
  var setting = ConnectionSettings(
    host: '127.0.0.1',
    port: 3306,
    user: 'admin',
    password: 'admin',
    db: 'stock_asset',
  );

  return await MySqlConnection.connect(setting);
}
