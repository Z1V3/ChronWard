import 'package:flutter/material.dart';
import '../modules/paypal/model/payment_data.dart';

abstract class PaymentService {
  String get apiPublicKey;

  String get apiSecretKey;

  String get paymentConfig;

  Future<bool> sendPaymentToBackend(String paymentToken, String backendUrl);

  Widget showPaymentDisplay(BuildContext context, PaymentData payment, Function(bool) onPaymentResult, {String? backendUrl, String? paymentConfig});
}
