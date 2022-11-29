import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/components/button.dart';
import 'package:inventory/components/scanner.dart';
import 'package:inventory/context.dart';
import 'package:inventory/controllers/account_controller.dart';
import 'package:inventory/controllers/category_controller.dart';
import 'package:inventory/controllers/inventory_controller.dart';
import 'package:inventory/models/category.dart';
import 'package:inventory/pages/category_details_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const route = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<Store>(context, listen: false).fetchCategory();
      await Provider.of<Store>(context, listen: false).fetchInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Management"),
        actions: [
          IconButton(
              onPressed: () async {
                logout(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  scannerButton(
                      context: context,
                      color: Colors.green,
                      func: () {
                        barcodeScanner().then((value) async {
                          // if (value != "-1") {
                          ItemCategory category = await getCategory(
                              barcode: value, context: context);
                          await addInventory(
                              category: category, context: context);

                          // }
                        });
                      },
                      label: "ADD"),
                  scannerButton(
                      context: context,
                      color: Colors.yellow,
                      func: () {
                        barcodeScanner().then((value) async {
                          // if (value != "-1") {
                          disposeInventory(barcode: value, context: context);
                          // }
                        });
                      },
                      label: "REMOVE"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Consumer<Store>(
                  builder: (context, store, child) => Text(
                        "Total Stock : ${store.getTotalStockCount()}",
                        style: const TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w600),
                      )),
            ),
            const Text(
              "Current Stock",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Consumer<Store>(
                builder: (context, store, child) {
                  List<TableRow> table = [
                    const TableRow(children: [
                      Text(
                        "Label",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Count",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ])
                  ];

                  for (var element in store.categories) {
                    table.add(TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableRowInkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryDetails(id: element.id)));
                            },
                            child: Text(
                              element.label,
                              style: const TextStyle(fontSize: 16),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          store
                              .getTotalStockCountByCategory(element)
                              .toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    ]));
                  }

                  return Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FractionColumnWidth(0.5),
                      1: FractionColumnWidth(0.5),
                    },
                    children: table,
                  );
                },
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
