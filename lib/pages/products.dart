import 'package:flutter/material.dart';
import 'package:book_management/database.dart';
import 'package:mysql1/mysql1.dart';

Future getPorducts() async {
  MySqlConnection db = await database();

  String sql = '';
  var results = await db.query(sql);

  if(results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Products')],
        ),
      ),
    );
  }
}