import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:android/presentation/drawer_widget.dart';

class ReceiptScreen extends StatelessWidget {
  final String chargingStationName;
  final String chargingStationLocation;
  final DateTime dateTimeOfCharge;
  final String vehicleIdentificationNumber;
  final double electricityConsumed;
  final double chargingPricePerKwh;
  final String paymentMethod;
  final String transactionId;

  const ReceiptScreen({
    Key? key,
    required this.chargingStationName,
    required this.chargingStationLocation,
    required this.dateTimeOfCharge,
    required this.vehicleIdentificationNumber,
    required this.electricityConsumed,
    required this.chargingPricePerKwh,
    required this.paymentMethod,
    required this.transactionId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double totalChargeCost = electricityConsumed * chargingPricePerKwh;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'chargeHistoryPage');
          },
        ),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.receipt, size: 40, color: Colors.blue),
              const SizedBox(height: 8.0),
              Text(
                'Receipt for Charging',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildReceiptRow(Icons.ev_station, 'Station Name:', chargingStationName),
              _buildReceiptRow(Icons.location_on, 'Location:', chargingStationLocation),
              _buildReceiptRow(Icons.calendar_today, 'Date and Time:', _formatDateTime(dateTimeOfCharge)),
              _buildReceiptRow(Icons.directions_car, 'Vehicle ID:', vehicleIdentificationNumber),
              _buildReceiptRow(Icons.flash_on, 'Electricity Consumed (kWh):', electricityConsumed.toStringAsFixed(2)),
              _buildReceiptRow(Icons.attach_money, 'Price per kWh:', '\$$chargingPricePerKwh'),
              Divider(height: 20, color: Colors.blue),
              _buildReceiptRow(Icons.money, 'Total Charge Cost:', '\$$totalChargeCost', fontWeight: FontWeight.bold),
              const SizedBox(height: 16.0),
              _buildReceiptRow(Icons.payment, 'Payment Method:', paymentMethod),
              _buildReceiptRow(Icons.receipt_long, 'Transaction ID:', transactionId),
              const SizedBox(height: 24.0),
              const Text('Thank you for using our electric vehicle charger!', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              const Text('Your vehicle\'s battery is now charged to 100%.'),
              const SizedBox(height: 8.0),
              const Text('Please come back and use us again soon!'),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.yMd().add_jm().format(dateTime);
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
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontWeight: fontWeight)),
          ],
        ),
      ],
    );
  }
}
