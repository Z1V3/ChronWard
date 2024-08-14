import 'package:android/presentation/add_card_page.dart';
import 'package:android/presentation/charge_mode_page.dart';
import 'package:android/presentation/charging_history.dart';
import 'package:android/presentation/login_page.dart';
import 'package:android/presentation/payment_page.dart';
import 'package:android/presentation/wallet_page.dart';
import 'package:android/presentation/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:android/presentation/user_mode_page.dart';
import 'package:core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:android/presentation/start_menu.dart';
import 'package:android/presentation/receipt_report.dart';
import 'package:android/presentation/rfid_cards_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FacebookAuth.instance.webAndDesktopInitialize(
    appId: "3654306511510288",
    cookie: true,
    xfbml: true,
    version: "v11.0",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          'rfidCardsPage': (context) => const RfidCardsPage(),
          'walletPageRoute': (context) => const WalletPage(),
          'paymentPageRoute': (context) => const PaymentPage(),
          'receiptRoute': (context) => ReceiptScreen(
            chargingStationName: 'Varaždin Charging Station',
            chargingStationLocation: 'Ulica Julija Merlića 9, 42000 Varaždin',
            dateTimeOfCharge: DateTime(2023, 12, 22, 12, 0, 0),
            vehicleIdentificationNumber: '123456789ABC',
            electricityConsumed: 30.5,
            chargingPricePerKwh: 0.506558,
            paymentMethod: 'Credit Card',
            transactionId: '1234567890',
      )
        }
      )
    );
  }
}
