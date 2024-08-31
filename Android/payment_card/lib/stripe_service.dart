import 'package:flutter/material.dart';
import 'package:payment_card/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// TODO interface koji implementira?
class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Widget stripeButton(BuildContext context, double amount, Function(bool) onPaymentSuccess){
    return ElevatedButton(
      onPressed: () async {
        int amountToSend = (amount*100).toInt();
        bool paymentSuccess = await makePayment(amountToSend);
        onPaymentSuccess(paymentSuccess);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5,
      ),
      child: const Text(
        "Pay with Card",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  Future<bool> makePayment(int amount) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(amount, "usd");
      if (paymentIntentClientSecret == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "EVCharge",
        ),
      );

      bool paymentSuccess = await _processPayment();
      if (paymentSuccess) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": amount,
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {
              "Authorization": "Bearer $stripeSecretKey",
              "Content-Type": 'application/x-www-form-urlencoded'
            }
        ),
      );
      if (response.data != null) {
        print(response.data);
        return response.data["client_secret"];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      print("Payment failed!");
      return false;
    }
  }
}
