import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:payment/interfaces/i_payment_service.dart';
import '../paypal/model/payment_data.dart';

class GooglePayService implements PaymentService{
  @override
  String apiPublicKey;
  @override
  String apiSecretKey;
  @override
  String paymentConfig;


  GooglePayService(this.apiPublicKey, this.apiSecretKey, this.paymentConfig);

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
  GooglePayButton showPaymentDisplay(BuildContext context, PaymentData payment, Function(bool) onPaymentSuccess, {String? backendUrl, String? paymentConfig}){
    return GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(paymentConfig!),
      paymentItems: [
        PaymentItem(
          label: 'Total',
          amount: payment.amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ],
      theme: GooglePayButtonTheme.light,
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) async {
        print(result);
        String token = result['paymentMethodData']['tokenizationData']['token'];
        bool paymentSuccess = await sendPaymentToBackend(token, backendUrl!);
        onPaymentSuccess(paymentSuccess); // Notify the PaymentPage of the result
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
