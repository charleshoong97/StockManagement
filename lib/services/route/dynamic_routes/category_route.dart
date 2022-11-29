import 'package:flutter/material.dart';
import 'package:inventory/pages/not_found_page.dart';
import 'package:inventory/pages/category_details_page.dart';

class CategoryRoute {
  static Widget getCategoryPage(String? slug) {
    if (slug != null && slug.isNotEmpty) {
      return CategoryDetails(id: slug);
    }
    return const NotFoundPage();
  }
}
