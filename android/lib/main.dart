import 'package:android/pages/add_card_page.dart';
import 'package:android/pages/charge_mode_page.dart';
import 'package:android/pages/charging_history.dart';
import 'package:android/pages/login_page.dart';
import 'package:android/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:android/pages/user_mode_page.dart';
import 'package:android/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:android/pages/start_menu.dart';
import 'package:android/pages/receipt_report.dart';

void main() {
  runApp(const MyApp());
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
          'startMenuRoute': (context) => const StartMenu(),
          'loginPageRoute': (context) => const LoginPage(),
          'registrationRoute': (context) => const RegistrationPage(),
          'chargeModePageRoute': (context) => const ChargeModePage(),
          'userModePageRoute': (context) => const UserModePage(),
          'chargeHistoryPageRoute': (context) => const ChargingHistoryPage(),
          'addCardPageRoute': (context) => const AddCardPage(),
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
