import 'package:flutter/material.dart';
import 'package:inventory/pages/login_page.dart';
import 'package:inventory/pages/not_found_page.dart';
import 'package:inventory/pages/category_details_page.dart';

class LoginRoute {
  static Widget getLoginEmailAddressFromSignUp(String? slug) {
    if (slug != null && slug.isNotEmpty) {
      return LoginPage(emailAddress: slug);
    }
    return const LoginPage();
  }
}
