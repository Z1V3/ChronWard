import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChargeModePage extends StatefulWidget {
  const ChargeModePage({Key? key}) : super(key: key);

  @override
  State<ChargeModePage> createState() => _ChargeModePageState();
}

class ChargingData {
  String startTime;
  String endTime;
  String chargeTime;
  double volume;
  double price;
  int userID;
  int chargerID;

  ChargingData({
    required this.startTime,
    required this.endTime,
    required this.chargeTime,
    required this.volume,
    required this.price,
    required this.userID,
    required this.chargerID,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'chargeTime': chargeTime,
      'volume': volume,
      'price': price,
      'userID': userID,
      'chargerID': chargerID,
    };
  }
}

class _ChargeModePageState extends State<ChargeModePage>{
  double counter = 0;
  double volumeCharge = 0, priceCharge = 0;
  late Timer _timer;
  bool isRunning = false;
  String formattedDateTimeStart = "/", formattedDateTimeEnd = "/", formattedDuration = "/";
  TextEditingController _textFieldController = TextEditingController();

  String formatCounterToDuration(int milliseconds) {
    // Convert milliseconds to a Duration
    Duration duration = Duration(milliseconds: milliseconds);

    // Extract hours, minutes, and seconds from the Duration
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);

    // Format the time string with leading zeros
    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  Future<void> sendCreateEvent(String startTime, String endTime, String chargeTime, double volume, double price) async {
    final Uri uri = Uri.parse('http://192.168.88.22:8080/api/event/createEvent');

    try {
      ChargingData chargingData = ChargingData(
        startTime: startTime,
        endTime: endTime,
        chargeTime: chargeTime,
        volume: volume,
        price: price,
        userID: 2,
        chargerID: 2,
      );

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(chargingData.toJson()),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        counter++;
      });
    });
  }

  void stopTimer() {
    _timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleButton(
              label: 'START',
              onClick: () {
                if (!isRunning) {
                  startTimer();
                  setState(() {
                    isRunning = true;
                  });
                  DateTime now = DateTime.now();
                  formattedDateTimeStart = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
                }
                print('START button clicked');
              },
            ),
            const SizedBox(height: 20),
            CircleButton(
              label: 'STOP',
              onClick: () {
                if (isRunning) {
                  stopTimer();

                  DateTime now = DateTime.now();
                  formattedDateTimeEnd = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);

                  counter = counter/10;
                  formattedDuration = formatCounterToDuration(counter.toInt());

                  volumeCharge = double.parse(((counter*2.361)/10).toStringAsExponential(3));
                  priceCharge = double.parse(((counter*1.5)/10).toStringAsExponential(3));

                  sendCreateEvent(formattedDateTimeStart, formattedDateTimeEnd, formattedDuration, volumeCharge, priceCharge);
                }
                print('Time charged: $counter seconds');
                print('Power: $volumeCharge');
                print('Price: $priceCharge');
                counter = 0;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final VoidCallback onClick;

  CircleButton({required this.label, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: 150,
        height: 150,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}