import 'package:android/domain/use_cases/fetch_user_history.dart';
import 'package:flutter/material.dart';
import 'package:core/services/history_data_manager_service.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';

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
    Future<bool> onWillPop() async {
      Navigator.pushReplacementNamed(context, 'userModePageRoute');
      return false;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Charging History',
            style: TextStyle(
                color: Colors.black
            ),
      ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue[100],

      ),
      drawer: const DrawerWidget(),
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
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'receiptRoute');
                  },
                  child: Text('Receipt'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
