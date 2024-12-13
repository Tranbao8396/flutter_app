import 'package:flutter/material.dart';
import 'package:book_management/database.dart';
import 'package:mysql1/mysql1.dart';

Future getInvoiceDetail(int id) async {
  MySqlConnection db = await database();
  String sql = 'SELECT a.invoice_id, b.book_name, SUM(a.quantity) as quantities, a.price * SUM(a.quantity) as prices FROM invoice_detail a LEFT JOIN imports b ON a.item = b.id WHERE a.invoice_id = $id GROUP BY a.item;';
  var results = await db.query(sql);

  if (results.isNotEmpty) {
    return results;
  } else {
    return null;
  }
}

class InvoiceDetail extends StatelessWidget {
  final int id;

  const InvoiceDetail({
    super.key,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Detail #$id'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTableExp(id: id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataTableExp extends StatelessWidget {
  final int id;

  const DataTableExp({
    super.key,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    final products = getInvoiceDetail(id);
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
                  DataCell(Text(row[1].toString())),
                  DataCell(Text(row[2].toString())),
                  DataCell(Text(row[3].toString())),
                ],
              )
            );
          }
        }

        return DataTable(
        showCheckboxColumn: false,
          columns: [
            DataColumn(
              label: Expanded(child: Text('Book'))
            ),
            DataColumn(
              label: Expanded(child: Text('Quantities'))
            ),
            DataColumn(
              label: Expanded(child: Text('Prices'))
            ),
          ],
          rows: dataRow,
        );
      }
    );
  }
}