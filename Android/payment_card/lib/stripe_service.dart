import 'package:core/interfaces/IPayment.dart';
import 'package:flutter/material.dart';
import 'package:payment_card/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService{
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
        backgroundColor: const Color.fromRGBO(96, 88, 247, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
        elevation: 5,
      ),
      child: const Text(
        "Pay with Card",
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              offset: Offset(1, 1),
            ),
          ],
        ),
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
