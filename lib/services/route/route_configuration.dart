import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory/pages/not_found_page.dart';
import 'package:inventory/pages/category_details_page.dart';
import 'package:inventory/pages/home_page.dart';
import 'package:inventory/pages/login_page.dart';
import 'package:inventory/pages/reset_password_page.dart';
import 'package:inventory/pages/signup_page.dart';
import 'package:inventory/pages/splash_page.dart';
import 'package:inventory/services/route/dynamic_routes/category_route.dart';
import 'package:inventory/services/route/dynamic_routes/login_route.dart';
import 'package:inventory/services/route/path.dart';

class RouteConfiguration {
  /// List of [Path] to for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [Path.pattern]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  static List<NavigationPath> paths = [
    NavigationPath(
      r'^' + LoginPage.route + r'(.*)$',
      (context, match) => LoginRoute.getLoginEmailAddressFromSignUp(match),
    ),
    NavigationPath(
      r'^' + SignUpPage.route,
      (context, match) => SignUpPage(),
    ),
    NavigationPath(
      r'^' + ResetPasswordPage.route,
      (context, match) => ResetPasswordPage(),
    ),
    NavigationPath(
      r'^' + CategoryDetails.baseRoute + r'/([\w-]+)$',
      (context, match) => CategoryRoute.getCategoryPage(match),
    ),
    NavigationPath(
      r'^' + HomePage.route,
      (context, match) => HomePage(),
    ),
    NavigationPath(
      r'^' + NotFoundPage.route,
      (context, match) => NotFoundPage(),
    ),
    NavigationPath(
      r'^' + SplashPage.route,
      (context, match) => SplashPage(),
    ),
  ];

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  static Route onGenerateRoute(RouteSettings settings) {
    // debugPrint("Path Name : ${settings.name!}");
    if ((FirebaseAuth.instance.currentUser) == null &&
        ![
          "/",
          SignUpPage.route,
          LoginPage.route,
          NotFoundPage.route,
          ResetPasswordPage.route
        ].contains(settings.name) &&
        !RegExp(r'^' + LoginPage.route + r'(.*)$').hasMatch(settings.name!)) {
      settings = settings.copyWith(name: LoginPage.route);
    }

    for (NavigationPath path in paths) {
      // debugPrint("Pattern : ${path.pattern}");
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name!)) {
        // debugPrint("Match : ${path.pattern}");

        final firstMatch = regExpPattern.firstMatch(settings.name!);
        final match = (firstMatch != null && firstMatch.groupCount == 1)
            ? firstMatch.group(1)!
            : '';
        // debugPrint("Value : $match");
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match),
          settings: settings,
        );
      }
    }

    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
