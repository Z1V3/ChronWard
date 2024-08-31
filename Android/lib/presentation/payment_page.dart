import 'package:flutter/material.dart';
import 'package:payment_google_pay/payment_google_pay.dart';
import 'package:payment_card/stripe_service.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';
import 'package:core/utils/google_config.dart';
import 'package:android/domain/controllers/wallet_controller.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  const PaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WalletController _walletController;

  @override
  void initState() {
    super.initState();
    _walletController = WalletController();
  }

  void _handleStripeResult(bool paymentSuccess) async {
    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is not available.')),
      );
      return;
    }
    if (paymentSuccess) {
      double wallet = await _walletController.fetchWallet(userId);
      wallet += widget.amount;
      await _walletController.updateWallet(userId, wallet);
      Navigator.pushReplacementNamed(context, 'walletPageRoute');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Card payment failed. Please try again.')),
      );
    }
  }

  void _handleGooglePayResult(bool paymentSuccess) async {
    if (paymentSuccess) {
      final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;

      if (userId != null) {
        double wallet = await _walletController.fetchWallet(userId);
        wallet += widget.amount;
        await _walletController.updateWallet(userId, wallet);
        Navigator.pushReplacementNamed(context, 'walletPageRoute');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID is not available.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Pay payment failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Payment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'walletPageRoute');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            StripeService.instance.stripeButton(
              context,
              widget.amount,
              _handleStripeResult
            ),

            const SizedBox(height: 20),
            GooglePayService.instance.googlePayButton(
              context,
              widget.amount,
              "http://your-backend-url.com/handle_google_pay",
              googlePayConfiguration,
              _handleGooglePayResult,
            ),
          ],
        ),
      ),
    );
  }
}
