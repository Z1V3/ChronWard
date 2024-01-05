import 'package:android/pages/charge_mode_page.dart';
import 'package:android/pages/charging_history.dart';
import 'package:android/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:android/pages/user_mode_interface.dart';
import 'package:android/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:android/pages/start_menu.dart';
import 'package:android/pages/receipt_report.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'EVCharge App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const StartMenu(),

        debugShowCheckedModeBanner: false,
        routes: {
          'myHomePageRoute': (context) => const MyHomePage(),
          'registrationRoute': (context) => const LoginPage(),
          'chargeModePageRoute': (context) => const ChargeModePage(),
          'chargeHistoryPage': (context) => const ChargingHistoryPage(),
          'startMenuRoute': (context) => const StartMenu(),
          'receiptRoute': (context) => ReceiptScreen(
            chargingStationName: 'Koprivnica Charging Station',
            chargingStationLocation: 'Koprivnica, Croatia',
            dateTimeOfCharge: DateTime(2023, 12, 22, 12, 0, 0),
            vehicleIdentificationNumber: '123456789ABC',
            electricityConsumed: 20.0,
            chargingPricePerKwh: 0.30,
            paymentMethod: 'Credit Card',
            transactionId: '1234567890',
      )
        }
      )
    );
  }
}
