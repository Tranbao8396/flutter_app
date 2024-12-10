import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:book_management/database.dart';

Future getTotalPrice() async {
  MySqlConnection db = await database();
  var result = await db.query('select sum(price) from invoice_detail');
  if (result.isNotEmpty) {
    return result;
  } else {
    return null;
  }
}

Future getImportPrice() async {
  MySqlConnection db = await database();
  var result = await db.query('select sum(import_price)*sum(quantity) from imports');
  if (result.isNotEmpty) {
    return result;
  } else {
    return null;
  }
}

class Dashboard extends StatelessWidget {
  final totalPrice = getTotalPrice();
  final importPrice = getImportPrice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Padding (
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: InfoCard(title: 'Income', results: totalPrice,)),
                Expanded(child: InfoCard(title: 'Outcome', results: importPrice,)),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final Future results;
  const InfoCard({
    super.key,
    required this.title,
    required this.results
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding (
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
              title
            ),
            Text('money')
          ],
        )
      )
    );
  }
}