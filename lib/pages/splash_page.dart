import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/constants/colors.dart';
import 'package:inventory/constants/images.dart';
import 'package:inventory/pages/home_page.dart';
import 'package:inventory/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const route = "/";

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  Widget appLanded() {
    return Container(
      height: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(appLogo),
          const SizedBox(
            height: 40,
          ),
          const LinearProgressIndicator(
            color: appColor,
            backgroundColor: Colors.transparent,
            minHeight: 20,
          )
        ],
      ),
    );
  }

  Future<void> checkCredential(BuildContext context) async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushReplacementNamed(HomePage.route);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkCredential(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: appLanded(),
    );
  }
}
