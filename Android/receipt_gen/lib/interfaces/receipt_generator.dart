import 'package:receipt_gen/models/receipt_model.dart';

abstract class IReceiptGenerator {
  Future<void> generateReceiptPdf(ChargeReceipt receipt);
}