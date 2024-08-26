import 'package:flutter/material.dart';
import 'package:payment_google_pay/payment_google_pay.dart';
import 'package:payment_card/stripe_service.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';
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
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;

                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User ID is not available.')),
                  );
                  return;
                }

                bool paymentSuccess = await StripeService.instance.makePayment(userId, (widget.amount * 100).toInt());

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
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
              child: Text(
                "Pay with Card",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            GooglePayService.instance.googlePayButton(context, widget.amount),
          ],
        ),
      ),
    );
  }
}
