import 'package:flutter/cupertino.dart';
import 'package:inventory/components/dialog.dart';
import 'package:inventory/context.dart';
import 'package:inventory/models/category.dart';
import 'package:provider/provider.dart';

Future<void> createCategory(
    {required String barcode,
    required String label,
    required BuildContext context,
    String description = ""}) async {
  await Provider.of<Store>(context, listen: false).createCategory(ItemCategory(
      barcode: barcode, label: label, description: description, id: ''));
}

Future<ItemCategory> getCategory({
  required String barcode,
  required BuildContext context,
}) async {
  var store = Provider.of<Store>(context, listen: false);

  var category = await store.getCategoryByBarcode(barcode);
  if (category == null) {
    await createInventoryDialog(context: context, barcode: barcode);
    category = await store.getCategoryByBarcode(barcode);
  }

  return category!;
}
