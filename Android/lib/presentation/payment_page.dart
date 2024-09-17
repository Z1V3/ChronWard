import 'package:flutter/material.dart';
import 'package:payment_google_pay/payment_google_pay.dart';
import 'package:payment_card/stripe_service.dart';
import 'package:payment_paypal/payment_paypal.dart';
import 'package:payment_paypal/model/payment_data.dart';
import 'package:payment_paypal/model/item_data.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';
import 'package:core/utils/google_config.dart';
import 'package:android/domain/controllers/wallet_controller.dart';
import 'package:core/utils/api_configuration.dart';
import 'package:payment19/payment19.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String description;
  final String itemName;
  final String quantity;
  final String currency;

  PaymentPage({
    Key? key,
    required this.amount,
    required this.description,
    required this.itemName,
    required this.quantity,
    required this.currency,
  }) : super(key: key);

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

  void _handlePaymentResult(bool paymentSuccess) async {
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
        SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ItemData> items = [];
    ItemData itemToAdd = ItemData(name: widget.itemName, quantity: widget.quantity, price: widget.amount, currency: widget.currency);
    items.add(itemToAdd);
    PaymentData paymentData = PaymentData(description: widget.description, amount: widget.amount, items: items);

    double buttonWidth = 250;
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              SizedBox(
                width: buttonWidth,
                child: StripeService.instance.stripeButton(
                  context,
                  widget.amount,
                  _handlePaymentResult,
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color.fromRGBO(0, 121, 193, 1),
                ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: const Center(
                    child: Text(
                      'Pay with PayPal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Color.fromRGBO(150, 200, 230, 1),
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
          TextButton(
            onPressed: () {
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: const Color.fromRGBO(0, 121, 193, 1),
            ),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(45),
              ),
              child: const Center(
                child: Text(
                  'Pay with PayPal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Color.fromRGBO(150, 200, 230, 1),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

              const SizedBox(height: 20),
              SizedBox(
                width: buttonWidth,
                child: TextButton(
                  onPressed: () {
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: const Color.fromRGBO(0, 121, 193, 1),
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: const Center(
                      child: Text(
                        'Pay with PayPal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 3.0,
                              color: Color.fromRGBO(150, 200, 230, 1),
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
