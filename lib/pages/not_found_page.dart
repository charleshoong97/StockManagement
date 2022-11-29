import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);
  static const route = "/404";

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text("Page not found"),
      ),
    );
  }
}
