import 'package:flutter/material.dart';
import 'package:book_management/database.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

Future getInvoices() async {
  MySqlConnection db = await database();
  String sql = 'SELECT b.id, b.created_date, SUM(a.price) FROM `invoice_detail` a LEFT JOIN invoices b ON a.invoice_id = b.id GROUP BY b.id;';
  var results = await db.query(sql);

  if (results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}

class Invoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTableExp(),
            ),
          ],
        ),
      ),
    );
  }
}

class DataTableExp extends StatelessWidget {
  final products = getInvoices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: products,
      builder: (context, snapshot) {
        var results = snapshot.data;
        List<DataRow> dataRow = [];
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          for (var row in results) {
            dataRow.add(
              DataRow(
                cells: <DataCell>[
                  DataCell(
                    Text(
                      row[0].toString()
                    )
                  ),
                  DataCell(
                    Text(
                      DateFormat.yMd().add_jm().format(row[1]).toString()
                    )
                  ),
                  DataCell(Text(row[2].toString())),
                ]
              )
            );
          }
        }

        return DataTable(
          columns: [
            DataColumn(
              label: Expanded(child: Text('ID'))
            ),
            DataColumn(
              label: Expanded(child: Text('Date'))
            ),
            DataColumn(
              label: Expanded(child: Text('Price'))
            ),
          ],
          rows: dataRow,
        );
      }
    );
  }
}