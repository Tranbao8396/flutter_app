import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:book_management/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

Future getTotalPrice() async {
  MySqlConnection db = await database();
  var result = await db.query('select (sum(price) - (select sum(import_price)*sum(quantity) from imports)) from invoice_detail');
  if (result.isNotEmpty) {
    return result;
  } else {
    return null;
  }
}

Future getImportPrice() async {
  MySqlConnection db = await database();
  var result =
      await db.query('select sum(import_price)*sum(quantity) from imports');
  if (result.isNotEmpty) {
    return result;
  } else {
    return null;
  }
}

Future getIncomebyDate() async {
  MySqlConnection db = await database();
  var results = await db.query(
      'SELECT b.created_date, sum(a.price) FROM invoice_detail a LEFT JOIN invoices b ON b.id = a.invoice_id GROUP BY b.created_date;');

  if (results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}

Future getSalersData() async {
  MySqlConnection db = await database();
  var results = await db.query('SELECT COUNT(*) as saler_count, b.user_name FROM `invoices` a LEFT JOIN users b ON a.user_id = b.id GROUP BY a.user_id;');

  if (results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}

Future getStorage() async {
  MySqlConnection db = await database();
  var results = await db.query('SELECT SUM(quantity) as quantities FROM `imports`');

  if (results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}

Future getPublishers() async {
  MySqlConnection db = await database();
  var results = await db.query('SELECT COUNT(*) as publisher_count FROM `book_supplier`');

  if (results.isNotEmpty) { 
    return results;
  } else {
    return null;
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _SalersData {
  _SalersData(this.name, this.invoices);

  final String name;
  final int invoices;
}

class Dashboard extends StatelessWidget {
  final totalPrice = getTotalPrice();
  final importPrice = getImportPrice();
  final storage = getStorage();
  final publisher = getPublishers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Income',
                    results: totalPrice,
                  )
                ),
                Expanded(
                  child: InfoCard(
                    title: 'Outcome',
                    results: importPrice,
                  )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Storage',
                    results: storage,
                  )
                ),
                Expanded(
                  child: InfoCard(
                    title: 'Publishers',
                    results: publisher,
                  )
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Padding(padding: const EdgeInsets.all(16), child: Chart())
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(padding: const EdgeInsets.all(16), child: SalersChart())
          ),
        ],
      )
    );
  }
}

class Chart extends StatelessWidget {
  final income = getIncomebyDate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: income,
        builder: (context, snapshot) {
          final result = snapshot.data;
          List<_SalesData> data = [];
          if (snapshot.hasData) {
            for (var row in result) {
              data.add(_SalesData(
                  DateFormat.yMd().add_jm().format(row[0]).toString(),
                  double.parse(row[1].toString())));
            }
          } else {
            data = [];
          }
          return SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries<_SalesData, String>>[
              LineSeries<_SalesData, String>(
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.year,
                yValueMapper: (_SalesData sales, _) => sales.sales,
                name: 'Sales',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ],
          );
        });
  }
}

class SalersChart extends StatelessWidget {
  final future = getSalersData();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final salesData = snapshot.data;
        List<_SalersData> data = [];
        if(snapshot.hasData) {
          for (var row in salesData) {
            data.add(
              _SalersData(row[1], row[0])
            );
          }
        } else {
          data = [];
        }
        return SfCartesianChart(
          primaryXAxis: CategoryAxis(),
            series: <CartesianSeries<_SalersData, String>>[
              ColumnSeries<_SalersData, String>(
                dataSource: data,
                xValueMapper: (_SalersData sales, _) => sales.name,
                yValueMapper: (_SalersData sales, _) => sales.invoices,
                name: 'Saler sales',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true)
              )
            ],
        );
      }
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final Future results;
  const InfoCard({super.key, required this.title, required this.results});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: results,
      builder: (context, snapshot) {
        final result = snapshot.data;
        List<Widget> children = [];

        if (snapshot.hasData) {
          for (var row in result) {
            children = <Widget>[Text(row[0].toString())];
          }
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
                    title
                  ),
                Column(
                  children: children,
                )
              ],
            )
          )
        );
      },
    );
  }
}
