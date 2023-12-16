import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChargingScreen(),
    );
  }
}

class ChargingScreen extends StatelessWidget {
  const ChargingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Charging Information',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/teslicaa.png',
                fit: BoxFit.fitHeight,
                height: 200,
              ),
            ),
            const Text(
              'Charging Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CustomLinearProgressIndicator(
              value: 0.7, // Replace with dynamic data (percentage of charging)
              additionalInfo: 'Charging in progress...', // Additional information
            ),
            const SizedBox(height: 20),
            const ChargingDetailCard(
              title: 'Voltage',
              value: '220V', // Replace with dynamic data
            ),
            const ChargingDetailCard(
              title: 'Price',
              value: '\$0.10/kWh', // Replace with dynamic data
            ),
            const ChargingDetailCard(
              title: 'Time Started',
              value: '12:30 PM', // Replace with dynamic data
            ),
            const ChargingDetailCard(
              title: 'Time Left',
              value: '2h 30m', // Replace with dynamic data
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  final double value;
  final String additionalInfo;

  const CustomLinearProgressIndicator({super.key, 
    required this.value,
    required this.additionalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: value,
            minHeight: 30,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            additionalInfo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ChargingDetailCard extends StatelessWidget {
  final String title;
  final String value;

  const ChargingDetailCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), // Adjust opacity as needed
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
