import 'package:android/pages/charge_mode_page.dart';
import 'package:android/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:android/pages/registration_page.dart';
import 'package:android/pages/start_menu.dart';
import 'package:android/pages/charging_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVCharge App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        'myHomePageRoute': (context) => MyHomePage(),
        'registrationRoute': (context) => LoginPage(),
        'chargeModePageRoute': (context) => ChargeModePage()
      }
    );
  }
}
