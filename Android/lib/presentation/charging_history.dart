import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:android/domain/use_cases/fetch_user_history.dart';
import 'package:core/services/history_data_manager_service.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';
import 'package:receipt_gen/modules/receipt_pdf//receipt_pdf.dart';
import 'package:receipt_gen/models/receipt_model.dart';
import 'package:receipt_gen/modules/receipt_widget/receipt_dialog.dart';

class ChargingHistoryPage extends StatefulWidget {
  final double pricePerKwh;
  const ChargingHistoryPage({Key? key, required this.pricePerKwh}) : super(key: key);

  @override
  State<ChargingHistoryPage> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryPage> {
  List chargingHistoryData = [];
  ReceiptGenerator _pdfGenerator = ReceiptGenerator();

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
    print(chargingHistoryData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Charging History',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          color: Colors.white70,
          child: ListView.builder(
            itemCount: chargingHistoryData.length,
            itemBuilder: (context, index) {
              final chargingHistoryItem = chargingHistoryData[index];
              final startTime = chargingHistoryItem['startTime'];
              final endTime = chargingHistoryItem['endTime'];
              final chargeTime = chargingHistoryItem['chargeTime'];
              final volume = chargingHistoryItem['volume'];
              final price = chargingHistoryItem['price'];
              final id = index + 1;

              final startTimeObject = DateTime.parse(startTime);
              final endTimeObject = DateTime.parse(endTime);
              final formattedStartTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(startTimeObject);
              final formattedEndTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(endTimeObject);

              ChargeReceipt receipt = ChargeReceipt(
                  id: id,
                  price: price,
                  startTime: formattedStartTime,
                  timeOfIssue: formattedEndTime,
                  chargeTime: chargeTime,
                  pricePerKwh: widget.pricePerKwh,
                  volume: volume
              );

              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Generate Receipt'),
                        content: Text('Select how you want to generate the receipt:'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ReceiptDialog(receipt: receipt);
                                },
                              );
                            },
                            child: Text('Generate in app'),
                          ),
                          TextButton(
                            onPressed: () async {
                              _pdfGenerator.generateReceiptPdf(receipt);
                            },
                            child: Text('Generate pdf'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.lightBlueAccent,
                              child: Text('${index + 1}'),
                            ),
                            Text('Receipt number ',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 8.0),
                          ],
                        ),
                        Text('Start Time: $formattedStartTime',
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                        Text('End Time: $formattedEndTime',
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                        Text('Price: $price, euro',
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
