import 'package:android/presentation/charge_mode_payment.dart';
import 'package:payment_card/consts.dart';
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
import 'package:android/presentation/statistics_page.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:receipt_gen/models/receipt_model.dart';

void main() async {
  await _setup();
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  FacebookAuth.instance.webAndDesktopInitialize(
    appId: "3654306511510288",
    cookie: true,
    xfbml: true,
    version: "v11.0",
  );
  runApp(const MyApp());
}

Future<void> _setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final double pricePerKwh = 0.15;

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
          'chargeModePaymentPageRoute': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            final double amount = args?['amount'] ?? 0.0;
            return ChargeModePaymentPage(amount: amount);
          },
          'userModePageRoute': (context) => const UserModePage(),
          'chargeHistoryPageRoute': (context) {
            return ChargingHistoryPage(pricePerKwh: pricePerKwh);
          },
          'addCardPageRoute': (context) => const AddCardPage(),
          'rfidCardsPage': (context) => const RfidCardsPage(),
          'walletPageRoute': (context) => const WalletPage(),
          'paymentPageRoute': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            final String description = args?['description'] ?? "";
            final String itemName = args?['itemName'] ?? "";
            final String quantity = args?['quantity'] ?? '0';
            final String currency = args?['currency'] ?? "USD";
            final double amount = args?['amount'] ?? 0.0;
            return PaymentPage(amount: amount, description: description, itemName: itemName, quantity: quantity, currency: currency);
          },
          'receiptRoute': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            final String startTime = args?['startTime'] ?? "";
            final String endTime = args?['endTime'] ?? "";
            final String chargeTime = args?['chargeTime'] ?? "";
            final double volume = args?['volume'] ?? 0.0;
            final double price = args?['price'] ?? 0.0;
            final int id = args?['id'] ?? 0;
            ChargeReceipt receipt = ChargeReceipt(id: id, price: price, startTime: startTime, timeOfIssue: endTime, chargeTime: chargeTime, pricePerKwh: pricePerKwh, volume: volume);
            return ReceiptScreen(receipt: receipt);
          },
          'statisticsPageRoute': (context) => const StatisticsPage(),
        },
      ),
    );
  }
}
