import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:android/privateAddress.dart';

class ChargingHistoryPage extends StatefulWidget {
  const ChargingHistoryPage({Key? key}) : super(key: key);

  @override
  State<ChargingHistoryPage> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryPage> {
  List chargingHistoryData = [];

  @override
  void initState() {
    super.initState();
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
          Navigator.pushReplacementNamed(context, 'myHomePageRoute');
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
            final charge_time = chargingHistoryItem['chargeTime'];
            final volume = chargingHistoryItem['volume'];
            final price = chargingHistoryItem['price'];
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index+1}'),
              ),
              title: Text('Time spent charging: $charge_time',style: TextStyle(
                color: Colors.white
              ),),
              subtitle: Text('${volume.toString()}, kWh. You paid: $price, euro'),




            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchUserHistory();
        },
      ),
    );
  }
  void fetchUserHistory() async {
    print('Fetching history');
    final url = 'http://${returnAddress()}:8080/api/event/getEventsByUserID/2';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      chargingHistoryData = json;
    });
    print(json);
    print('Fetch charging history finished');
  }
}

