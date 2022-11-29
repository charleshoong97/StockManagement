import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/constants/variables.dart';
import 'package:inventory/context.dart';
import 'package:inventory/models/category.dart';
import 'package:inventory/models/item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CategoryDetails extends StatefulWidget {
  static const baseRoute = "/category";
  final String id;

  const CategoryDetails({Key? key, required this.id}) : super(key: key);

  @override
  CategoryDetailsState createState() => CategoryDetailsState();
}

class CategoryDetailsState extends State<CategoryDetails> {
  static const TextStyle labelStyle =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w500);
  static const TextStyle valueStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w300);

  Widget labelValue(
      {required String label,
      required String value,
      required String name,
      bool editable = true,
      bool mandatory = false}) {
    final ValueNotifier<bool> _editable = ValueNotifier<bool>(false);
    final TextEditingController _valueController =
        TextEditingController(text: value);
    final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();

    Future<void> saveValue(newValue) async {
      if (_formFieldKey.currentState!.validate()) {
        _editable.value = !_editable.value;
        if (await Provider.of<Store>(context, listen: false)
            .updateCategory(id: widget.id, param: name, value: newValue)) {
          value = newValue;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: labelStyle,
              ),
              ValueListenableBuilder<bool>(
                builder: (BuildContext context, bool edit, Widget? child) {
                  if (edit && editable) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        key: _formFieldKey,
                        controller: _valueController,
                        autofocus: true,
                        validator: (newValue) {
                          if (mandatory &&
                              (newValue == null || newValue.isEmpty)) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        onFieldSubmitted: saveValue,
                      ),
                    );
                  } else {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          value != '' ? value : "-",
                          style: valueStyle,
                        ));
                  }
                },
                valueListenable: _editable,
              )
            ],
          ),
          Visibility(
              visible: editable,
              child: GestureDetector(
                  onTap: () {
                    if (_editable.value) {
                      saveValue(_valueController.text);
                    } else {
                      _editable.value = !_editable.value;
                    }
                  },
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _editable,
                    builder: (BuildContext context, bool edit, Widget? child) {
                      if (edit) {
                        return const Icon(Icons.save);
                      } else {
                        return const Icon(Icons.edit);
                      }
                    },
                  )))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemCategory? category =
        Provider.of<Store>(context, listen: true).getCategoryById(widget.id);

    if (category == null) {
      return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: Text("Unable to find this category"),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(category.label),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      labelValue(
                        label: "Barcode",
                        value: category.barcode,
                        name: barcode,
                        editable: false,
                      ),
                      labelValue(
                          label: "Label",
                          value: category.label,
                          name: label,
                          mandatory: true),
                      labelValue(
                          label: "Description",
                          value: category.description,
                          name: description),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50, top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Current available stock : ",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Consumer<Store>(
                              builder: (context, store, child) => Text(
                                store
                                    .getTotalStockCountByCategory(category)
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Center(
                          child: Text(
                        "History",
                        style: labelStyle,
                      )),
                      Consumer<Store>(builder: (context, store, child) {
                        List<TableRow> table = [
                          const TableRow(children: [
                            Text(
                              "Id",
                              style: TextStyle(height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Added Datetime",
                              style: TextStyle(height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Disposed Datetime",
                              style: TextStyle(height: 1.5),
                              textAlign: TextAlign.center,
                            )
                          ])
                        ];

                        List<Item> disposeItems =
                            store.getDisposeItemsByCategory(category);

                        if (disposeItems.isEmpty) {
                          return const SizedBox(
                            height: 100,
                            child: Center(
                                child: Text(
                                    "No history for this kind of inventory")),
                          );
                        }

                        disposeItems.asMap().forEach((index, element) {
                          table.add(TableRow(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat('yyyy/MM/dd hh:mm')
                                    .format(element.addedDate)
                                    .toString(),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat('yyyy/MM/dd hh:mm')
                                    .format(element.disposeDate!)
                                    .toString(),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ]));
                        });

                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Table(
                            border: TableBorder.all(color: Colors.black),
                            columnWidths: const {
                              0: FractionColumnWidth(0.2),
                              1: FractionColumnWidth(0.4),
                              2: FractionColumnWidth(0.4),
                            },
                            children: table,
                          ),
                        );
                      })
                    ])),
          ));
    }
  }
}
