import 'package:flutter/material.dart';
import 'package:inventory/context.dart';
import 'package:inventory/pages/home_page.dart';
import 'package:inventory/pages/login_page.dart';
import 'package:inventory/services/route/route_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Store>(create: (_) => Store()),
      ],
      child: MaterialApp(
        title: 'Scanner',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "OpenSans"),
        onGenerateRoute: RouteConfiguration.onGenerateRoute,
      ),
    );
  }
}
