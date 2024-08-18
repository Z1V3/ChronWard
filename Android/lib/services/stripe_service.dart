import 'package:android/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ws/privateAddress.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(int userId, int amount) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(amount, "usd");
      if (paymentIntentClientSecret == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "EVCharge",
        ),
      );

      // Wait for the payment process to complete
      bool paymentSuccess = await _processPayment();
      print("STRIPE SERVICE");
      print(paymentSuccess);
      if (paymentSuccess) {
        // Only update the wallet if payment is successful
        await updateWalletValue(userId, (amount.toDouble() / 100));
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
              "Authorization": "Bearer ${stripeSecretKey}",
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
      return true; // Payment succeeded
    } catch (e) {
      print("Payment failed!");
      // TODO: Notify the user about the failure
      return false; // Payment failed
    }
  }

  Future<void> updateWalletValue(int userId, double amount) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/user/updateWalletValue');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'wallet': amount,
        }),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }
}
