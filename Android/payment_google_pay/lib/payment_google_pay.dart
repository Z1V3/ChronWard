import 'dart:convert';
import 'package:core/interfaces/IPayment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart';

class GooglePayService{
  GooglePayService._();

  static final GooglePayService instance = GooglePayService._();

  Future<bool> handlePayment(String paymentToken, String backendUrl) async {
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
        return false;
      }
    } catch (e) {
      print('Error handling payment: $e');
      return false;
    }
  }

  Widget showButton(BuildContext context, double amount, String backendUrl, String paymentConfig, Function(bool) onPaymentResult) {
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
        bool paymentSuccess = await handlePayment(token, backendUrl);
        onPaymentResult(paymentSuccess);
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
