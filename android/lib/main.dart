import 'package:flutter/material.dart';
import 'pages/start_menu.dart';
import 'pages/login_page.dart';
import 'package:android/pages/registration_page.dart';

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
      home: const RegistrationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
