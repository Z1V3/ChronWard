import 'package:payment/modules/paypal/model/item_data.dart';

class PaymentData{
  String description;
  double amount;
  List<ItemData> items = [];

  PaymentData({
    required this.description,
    required this.amount,
    required this.items
  });
}