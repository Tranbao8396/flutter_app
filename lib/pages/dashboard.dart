import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:book_management/database.dart';
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding (
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: InfoCard()),
            Expanded(child: InfoCard()),
          ],
        ),
      )
    );
  }
}

class InfoCard extends StatelessWidget {
  // final MySqlConnection db;

  const InfoCard({
    super.key
    // required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding (
        padding: const EdgeInsets.all(16),
        child: Text('money')
      )
    );
  }
}