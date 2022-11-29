import 'package:inventory/models/category.dart';

class Item {
  final String id;
  final ItemCategory category;
  final DateTime addedDate;
  DateTime? disposeDate;

  Item(
      {required this.id,
      required this.category,
      required this.addedDate,
      this.disposeDate});
}
