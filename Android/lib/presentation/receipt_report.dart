import 'package:flutter/material.dart';
import 'package:receipt_gen/models/receipt_model.dart';

class ReceiptScreen extends StatefulWidget {
  final ChargeReceipt receipt;

  const ReceiptScreen({
    Key? key,
    required this.receipt
  }) : super(key: key);

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'chargeHistoryPageRoute');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.receipt, size: 40, color: Colors.blue),
              const SizedBox(height: 8.0),
              const Text(
                'Receipt for Charging',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildReceiptRow(Icons.ev_station, 'Station Name: ', "EVCharge"),
              _buildReceiptRow(Icons.location_on, 'Location: ', "Varazdin"),
              _buildReceiptRow(Icons.calendar_today, 'Start Date and Time: ', widget.receipt.startTime),
              _buildReceiptRow(Icons.calendar_today, 'End Date and Time: ', widget.receipt.timeOfIssue),
              _buildReceiptRow(Icons.flash_on, 'Electricity Consumed (kWh): ', widget.receipt.volume.toString()),
              _buildReceiptRow(Icons.attach_money, 'Price per kWh: ', widget.receipt.pricePerKwh.toString()),
              const Divider(height: 20, color: Colors.blue),
              _buildReceiptRow(Icons.money, 'Total Charge Cost: ', widget.receipt.price.toString(), fontWeight: FontWeight.bold),
              const SizedBox(height: 16.0),
              _buildReceiptRow(Icons.receipt_long, 'Receipt ID:', widget.receipt.id.toString()),
              const SizedBox(height: 24.0),
              const Text('Thank you for using our electric vehicle charger!', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              const Text('Please come back and use us again soon!'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(IconData icon, String label, String value, {FontWeight fontWeight = FontWeight.normal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontWeight: fontWeight)),
          ],
        ),
      ],
    );
  }
}
