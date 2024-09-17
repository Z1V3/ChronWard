import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment/interfaces/i_payment_service.dart';
import 'model/item_data.dart';
import 'model/payment_data.dart';

class PayPalService implements PaymentService{
  @override
  String apiPublicKey;
  @override
  String apiSecretKey;
  @override
  String paymentConfig;

  PayPalService(this.apiPublicKey, this.apiSecretKey, this.paymentConfig);

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
  Widget showPaymentDisplay(BuildContext context, PaymentData payment, Function(bool) onPaymentResult, {String? backendUrl, String? paymentConfig}) {
    List paypalItems = payment.items.map((ItemData item) {
      return {
        "name": item.name,
        "quantity": item.quantity,
        "price": item.price.toString(),
        "currency": item.currency,
      } as Map<String, dynamic>;
    }).toList();

    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => PaypalCheckoutView(
            sandboxMode: true,
            clientId: "AeD5d-VxqFV1darFGMngXyAdakrfsEcLDpWqEhfHtJY1HBdB9iWQOmnS62OfKQwlB2YDC216LEyDoYz5",
            secretKey: "EM2CLYqvEt8xExXi9MoRr41PZysPZnLro6r60k9bOkp71jSTZ2ofvVK9Wmm_aU9zBp2uqKkSTuukq0SX",
            transactions: [
              {
                "amount": {
                  "total": payment.amount.toString(),
                  "currency": payment.items.first.currency,
                  "details": {
                    "subtotal": payment.amount.toString(),
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": payment.description,
                "item_list": {
                  "items": paypalItems,
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              onPaymentResult(true);
              Navigator.pop(context);
            },
            onError: (error) {
              print("onError: $error");
              onPaymentResult(false);
              Navigator.pop(context);
            },
            onCancel: () {
              print('cancelled:');
              onPaymentResult(false);
              Navigator.pop(context);
            },
          ),
        ));
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
    );
  }
}
