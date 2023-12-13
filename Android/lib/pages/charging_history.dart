import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChargingHistoryScreen extends StatefulWidget {
  const ChargingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChargingHistoryScreen> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryScreen> {
  List<ChargingHistoryData> chargingHistoryData = [];

  Future<void> fetchChargingHistory() async {
    const url = 'https://your-api-url/charging-history';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final chargingHistoryJson = jsonDecode(response.body);
      for (var chargingHistoryItem in chargingHistoryJson) {
        chargingHistoryData.add(ChargingHistoryData.fromJson(chargingHistoryItem));
      }
      setState(() {});
    } else {
      throw Exception('Failed to fetch charging history');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChargingHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Charging History',
            style: TextStyle(
                color: Colors.white
            ),
          ), leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
          centerTitle: true,
          backgroundColor: Colors.black87
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
        ),
        child: ListView.builder(
          itemCount: chargingHistoryData.length,
          itemBuilder: (context, index) {
            final chargingHistoryItem = chargingHistoryData[index];
            return Card(
              child: ListTile(
                title: Text('Date Charged: ${chargingHistoryItem.dateCharged}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: ${chargingHistoryItem.price}'),
                    Text('Time Charged: ${chargingHistoryItem.timeCharged}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChargingHistoryData {
  String dateCharged;
  double price;
  String timeCharged;

  ChargingHistoryData({
    required this.dateCharged,
    required this.price,
    required this.timeCharged,
  });

  factory ChargingHistoryData.fromJson(Map<String, dynamic> json) {
    return ChargingHistoryData(
      dateCharged: json['dateCharged'],
      price: json['price'],
      timeCharged: json['timeCharged'],
    );
  }
}
