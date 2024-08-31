import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

// TODO interface koji implementira?
class GooglePayService {
  GooglePayService._();

  static final GooglePayService instance = GooglePayService._();

  // TODO always returns true becaues this function has not been finished and the backendUrl is test and it is set in payment page
  Future<bool> handlePaymentToken(String paymentToken, String backendUrl) async {
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

  GooglePayButton googlePayButton(BuildContext context, double amount, String backendUrl, String paymentConfig, Function(bool) onPaymentSuccess) {
    return GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(paymentConfig),
      paymentItems: [
        PaymentItem(
          label: 'Total',
          amount: amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ],
      theme: GooglePayButtonTheme.light,
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) async {
        print(result);
        String token = result['paymentMethodData']['tokenizationData']['token'];
        bool paymentSuccess = await handlePaymentToken(token, backendUrl);
        onPaymentSuccess(paymentSuccess); // Notify the PaymentPage of the result
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
