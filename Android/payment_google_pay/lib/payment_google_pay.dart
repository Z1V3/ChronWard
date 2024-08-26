import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class GooglePayService {
  GooglePayService._();

  static final GooglePayService instance = GooglePayService._();

  // TODO odluci kaj bude sa ovom funkcijom
  final String _backendUrl = 'http://your-backend-url.com/handle_google_pay';

  Future<void> handlePaymentToken(String paymentToken) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'paymentToken': paymentToken,
        }),
      );

      if (response.statusCode == 200) {
        print('Payment handled successfully');
      } else {
        print('Failed to handle payment. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error handling payment: $e');
    }
  }

  //TODO izdovji konfiguraciju u poseban file
  Widget googlePayButton(BuildContext context, double amount) {
    return GooglePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
        '''{
        "provider": "google_pay",
        "data": {
          "environment": "TEST",
          "apiVersion": 2,
          "apiVersionMinor": 0,
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "parameters": {
                "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                "allowedCardNetworks": ["AMEX", "DISCOVER", "JCB", "MASTERCARD", "VISA"]
              },
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {
                  "gateway": "example", 
                  "gatewayMerchantId": "exampleMerchantId"
                }
              }
            }
          ],
          "merchantInfo": {
            "merchantId": "exampleMerchantId",
            "merchantName": "Example Merchant"
          },
          "transactionInfo": {
            "totalPriceStatus": "FINAL",
            "totalPriceLabel": "Total",
            "currencyCode": "USD",
            "countryCode": "US"
          }
        }
      }''',
      ),
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
        Navigator.pushReplacementNamed(context, 'walletPageRoute');
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
