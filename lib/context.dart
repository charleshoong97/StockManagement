import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory/constants/firebase.dart';
import 'package:inventory/constants/variables.dart';
import 'package:inventory/models/category.dart';
import 'package:inventory/models/item.dart';
import 'package:inventory/services/firebase.dart';

class Store with ChangeNotifier {
  List<Item> _inventories = [];
  List<ItemCategory> _categories = [];

  List<ItemCategory> get categories => _categories;

  void resetAll() {
    _inventories = [];
    _categories = [];
  }

  Future<bool> fetchCategory() async {
    try {
      print("----- Fetch Category -----");
      var result = await readData(
          path: '$categoryPath${FirebaseAuth.instance.currentUser!.uid}');
      if (result != null) {
        _categories.clear();
        Map<String, dynamic>.from(result).forEach((key, value) {
          _categories.add(ItemCategory(
              id: key,
              barcode: value['barcode'],
              label: value['label'],
              description: value['description'] ?? ''));
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> fetchInventory() async {
    try {
      print("----- Fetch Inventory -----");
      var result = await readData(
          path: '$itemPath${FirebaseAuth.instance.currentUser!.uid}');
      if (result != null) {
        _inventories.clear();
        Map<String, dynamic>.from(result).forEach((key, value) {
          _inventories.add(Item(
            id: key,
            category: _categories
                .firstWhere((element) => element.id == value['category']),
            addedDate: DateTime.parse(value['added_date']),
            disposeDate: value['dispose_date'] != null
                ? DateTime.parse(value['dispose_date'])
                : null,
          ));
        });
        notifyListeners();
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<void> addInventory(Item item) async {
    if (await writeNewObjectData(data: {
      category: item.category.id,
      addedDate: item.addedDate.toString()
    }, path: '$itemPath${FirebaseAuth.instance.currentUser!.uid}')) {
      await fetchInventory();
    }
  }

  Future<void> createCategory(ItemCategory category) async {
    if (await writeNewObjectData(data: {
      barcode: category.barcode,
      label: category.label,
      description: category.description
    }, path: '$categoryPath${FirebaseAuth.instance.currentUser!.uid}')) {
      await fetchCategory();
      notifyListeners();
    }
  }

  Future<bool> updateCategory(
      {required String id,
      required String param,
      required String value}) async {
    if (await writeSpecificExistData(
        data: value,
        path:
            '$categoryPath${FirebaseAuth.instance.currentUser!.uid}/$id/$param')) {
      _categories.forEach((e) {
        if (e.id == id) {
          switch (param) {
            case barcode:
              e.barcode = value;
              break;
            case label:
              e.label = value;
              break;
            case description:
              e.description = value;
              break;
          }
        }
      });
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<ItemCategory?> getCategoryByBarcode(String barcode) async {
    try {
      // await fetchCategory();
      return _categories.firstWhere(
        (category) => category.barcode == barcode,
      );
    } catch (e) {
      return null;
    }
  }

  ItemCategory? getCategoryById(String id) {
    try {
      // await fetchCategory();
      return _categories.firstWhere(
        (category) => category.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Item?> getInventory(String id) async {
    try {
      // await fetchInventory();
      return _inventories.firstWhere(
        (inventory) => inventory.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  int getTotalStockCount() {
    return _inventories.where((element) => element.disposeDate == null).length;
  }

  int getTotalStockCountByCategory(ItemCategory category) {
    return _inventories
        .where((element) =>
            element.category.id == category.id && element.disposeDate == null)
        .length;
  }

  Future<String> disposeItem(ItemCategory category) async {
    DateTime currDateTime = DateTime.now();

    await fetchInventory();

    List<Item> itemList = _inventories
        .where((element) =>
            element.category.id == category.id && element.disposeDate == null)
        .toList();
    itemList.sort((a, b) => a.addedDate.compareTo(b.addedDate));

    Item disposeItem = itemList[0];

    print("----- Dispose Item ${disposeItem.id} -----");
    if (await writeSpecificNewData(
        data: {disposeDate: currDateTime.toString()},
        path:
            '$itemPath${FirebaseAuth.instance.currentUser!.uid}/${disposeItem.id}')) {
      await fetchInventory();
      Item item =
          _inventories.firstWhere((matched) => matched.id == disposeItem.id);
      return item.disposeDate != null ? "success" : "failed";
    }
    return "failed";
  }

  List<Item> getDisposeItemsByCategory(ItemCategory category) {
    return _inventories
        .where((element) =>
            element.disposeDate != null && element.category == category)
        .toList();
  }
}
