
import 'package:flutter/material.dart';
import 'package:book_management/database.dart';
import 'package:mysql1/mysql1.dart';
import 'package:book_management/pages/productssearch.dart';

Future getPorducts() async {
  MySqlConnection db = await database();

  String sql = 'SELECT a.id, a.book_name, b.price, a.quantity, c.supplier, d.category_name FROM `imports` a Left JOIN book_store b ON a.id = b.book_id LEFT JOIN book_supplier c ON a.sup_id = c.id LEFT JOIN books_category d ON b.category_id = d.id';
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
    final searchController = TextEditingController(); 

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            String search = searchController.text;

                            if (search != '') {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsSearch(search: search),
                                )
                              );
                            } else {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Please type text to search'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Text('Search'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
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
                child: DataTableExp(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataTableExp extends StatelessWidget {
  final products = getPorducts();
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
                  DataCell(Text(row[0].toString())),
                  DataCell(Text(row[1].toString())),
                  DataCell(Text(row[2].toString())),
                  DataCell(Text(row[3].toString())),
                  DataCell(Text(row[4].toString())),
                  DataCell(Text(row[5].toString())),
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
              label: Expanded(child: Text('Name'))
            ),
            DataColumn(
              label: Expanded(child: Text('Price'))
            ),
            DataColumn(
              label: Expanded(child: Text('Quantity'))
            ),
            DataColumn(
              label: Expanded(child: Text('Publiser'))
            ),
            DataColumn(
              label: Expanded(child: Text('Category'))
            ),
          ],
          rows: dataRow,
        );
      }
    );
  }
}