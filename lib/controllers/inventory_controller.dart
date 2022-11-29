import 'package:flutter/cupertino.dart';
import 'package:inventory/context.dart';
import 'package:inventory/models/category.dart';
import 'package:inventory/models/item.dart';
import 'package:provider/provider.dart';

Future<void> addInventory(
    {required ItemCategory category, required BuildContext context}) async {
  DateTime currDateTime = DateTime.now();
  String currUser = "Admin";

  await Provider.of<Store>(context, listen: false)
      .addInventory(Item(category: category, addedDate: currDateTime, id: ''));
}

Future<String> disposeInventory(
    {required String barcode, required BuildContext context}) async {
  var store = Provider.of<Store>(context, listen: false);

  ItemCategory? category = await store.getCategoryByBarcode(barcode);

  if (category == null) {
    return "Item not found";
  }
  int count = store.getTotalStockCountByCategory(category);

  if (count == 0) {
    return "Item not found";
  }
  print("barcode");
  print(category.barcode);
  return await store.disposeItem(category);
}
