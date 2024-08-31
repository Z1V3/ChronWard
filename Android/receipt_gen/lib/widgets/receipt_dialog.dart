import 'package:flutter/material.dart';
import 'package:receipt_gen/models/receipt_model.dart';

class ReceiptDialog extends StatelessWidget {
  final ChargeReceipt receipt;

  const ReceiptDialog({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              _buildReceiptRow(Icons.calendar_today, 'Start Date and Time: ', receipt.startTime),
              _buildReceiptRow(Icons.calendar_today, 'End Date and Time: ', receipt.timeOfIssue),
              _buildReceiptRow(Icons.flash_on, 'Electricity Consumed (kWh): ', receipt.volume.toString()),
              _buildReceiptRow(Icons.attach_money, 'Price per kWh: ', receipt.pricePerKwh.toString()),
              const Divider(height: 20, color: Colors.blue),
              _buildReceiptRow(Icons.money, 'Total Charge Cost: ', receipt.price.toString(), fontWeight: FontWeight.bold),
              const SizedBox(height: 16.0),
              _buildReceiptRow(Icons.receipt_long, 'Receipt ID:', receipt.id.toString()),
              const SizedBox(height: 24.0),
              const Text('Thank you for using our electric vehicle charger!', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              const Text('Please come back and use us again soon!'),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
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
