import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:book_management/database.dart';
class Dashboard extends StatelessWidget {
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
                Expanded(child: InfoCard(title: 'Income')),
                Expanded(child: InfoCard(title: 'Outcome')),
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
  const InfoCard({
    super.key,
    required this.title
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