import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:book_management/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

List<_SalesData> data = [
  _SalesData('Jan', 35),
  _SalesData('Feb', 28),
  _SalesData('Mar', 34),
  _SalesData('Apr', 32),
  _SalesData('May', 40)
];

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

          Card(
            margin: const EdgeInsets.all(16),
            child: Padding (
              padding: const EdgeInsets.all(16),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
                ],
              )
            )
          ),
        ]
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
    return FutureBuilder(
      future: results,
      builder: (context, snapshot) {
        final result = snapshot.data;
        List<Widget> children = [];

        if (snapshot.hasData) {
          for (var row in result) {
            children = <Widget>[
              Text(row[0].toString())
            ];
          }
        }

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
                Column(children: children,)
              ],
            )
          )
        );
      },
    );
  }
}