import 'package:android/domain/use_cases/fetch_user_history.dart';
import 'package:flutter/material.dart';
import 'package:core/services/history_data_manager_service.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';

class ChargingHistoryPage extends StatefulWidget {
  const ChargingHistoryPage({super.key});

  @override
  State<ChargingHistoryPage> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryPage> {
  static List chargingHistoryData = [];

  @override
  void initState() {
    super.initState();
    fetchChargingHistoryData();
  }

  Future<void> fetchChargingHistoryData() async {
    await FetchHistoryService.fetchUserHistory(context);
    setState(() {
      chargingHistoryData = HistoryDataManager.chargingHistoryList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Charging History',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
      ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'userModePageRoute');
          },
        ),
      ),
      drawer: const DrawerWidget(),
      body: PopScope(
        child: Container(
          color: Colors.white70,

          child: ListView.builder(
            itemCount: chargingHistoryData.length,
            itemBuilder: (context, index) {
              final chargingHistoryItem = chargingHistoryData[index];
              final chargeTime = chargingHistoryItem['chargeTime'];
              final volume = chargingHistoryItem['volume'];
              final price = chargingHistoryItem['price'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.lightBlueAccent,
                  child: Text('${index+1}'),
                ),
                title: Text('Time spent charging: $chargeTime',style: const TextStyle(
                  color: Colors.black87
                ),),
                subtitle: Text('${volume.toString()}, kWh. You paid: $price, euro'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'receiptRoute');
                  },
                  child: const Text('Receipt'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
