import 'dart:io';
import 'package:android/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/payment_configuration.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  const PaymentPage({Key? key, required this.amount}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

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
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async {
                final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;

                if (userId == null) {
                  // Handle the case where the user ID is null
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User ID is not available.')),
                  );
                  return;
                }

                // Start the payment process
                bool paymentSuccess = await StripeService.instance.makePayment(userId, (widget.amount * 100).toInt());

                if (paymentSuccess) {
                  // Navigate to wallet page only if payment is successful
                  Navigator.pushReplacementNamed(context, 'walletPageRoute');
                } else {
                  // Handle payment failure scenario
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment failed. Please try again.')),
                  );
                }
              },
              color: Colors.green,
              child: const Text("Pay"),
            ),
          ],
        ),
      ),
    );
  }
}
