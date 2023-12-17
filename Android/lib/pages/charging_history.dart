import 'dart:convert';
import 'package:android/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    Future<bool> onWillPop() async {
      Navigator.pushReplacementNamed(context, 'myHomePageRoute');
      return false;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Charging History',
            style: TextStyle(
                color: Colors.black
            ),
          // ), leading: IconButton(
        // icon: const Icon(Icons.arrow_back, color: Colors.black),
        // onPressed: () {
        //   Navigator.pushReplacementNamed(context, 'myHomePageRoute');
        // },
      ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue[100],

      ),
      drawer: const YourDrawerWidget(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.lightBlue[100],

          child: ListView.builder(
            itemCount: chargingHistoryData.length,
            itemBuilder: (context, index) {
              final chargingHistoryItem = chargingHistoryData[index];
              final chargeTime = chargingHistoryItem['chargeTime'];
              final volume = chargingHistoryItem['volume'];
              final price = chargingHistoryItem['price'];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index+1}'),
                ),
                title: Text('Time spent charging: $chargeTime',style: const TextStyle(
                  color: Colors.black
                ),),
                subtitle: Text('${volume.toString()}, kWh. You paid: $price, euro'),




              );
            },
          ),
        ),
      ),

      floatingActionButton: SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(onPressed: () {
            fetchUserHistory();
          },
          child: const Text('Show history', textAlign: TextAlign.center,),),
        ),
      ),
    );
  }
  void fetchUserHistory() async {

    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;
    print('Fetching history');
    final url = 'http://${returnAddress()}:8080/api/event/getEventsByUserID/$userId';
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
class YourDrawerWidget extends StatelessWidget {
  const YourDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color myColor = Color(0xFFADD8E6);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: myColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'myHomePageRoute');

            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('My Cards'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Card'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
