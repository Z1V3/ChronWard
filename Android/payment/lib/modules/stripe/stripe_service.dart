import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:payment/interfaces/i_payment_service.dart';
import 'package:payment/modules/stripe/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../paypal/model/payment_data.dart';

class StripeService implements PaymentService{
  @override
  String apiPublicKey;
  @override
  String apiSecretKey;
  @override
  String paymentConfig;


  StripeService(this.apiPublicKey, this.apiSecretKey, this.paymentConfig);

  @override
  Future<bool> sendPaymentToBackend(String paymentToken, String backendUrl) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'paymentToken': paymentToken,
        }),
      );

      if (response.statusCode == 200) {
        print('Payment handled successfully');
        return true;
      } else {
        print('Failed to handle payment. Status: ${response.statusCode}');
        return true;
      }
    } catch (e) {
      print('Error handling payment: $e');
      return true;
    }
  }

  @override
  Widget showPaymentDisplay(BuildContext context, PaymentData payment, Function(bool) onPaymentSuccess, {String? backendUrl, String? paymentConfig}){
    return ElevatedButton(
      onPressed: () async {
        int amountToSend = (payment.amount*100).toInt();
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
