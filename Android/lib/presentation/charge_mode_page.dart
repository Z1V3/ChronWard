import 'dart:async';
import 'package:android/domain/use_cases/create_charging_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:core/utils/duration_formatter.dart';
import 'package:android/domain/controllers/charger_controller.dart';
import 'package:ws/services/charging_service.dart';
import 'package:android/domain/use_cases/update_charger_availability.dart';


class ChargeModePage extends StatefulWidget {
  const ChargeModePage({Key? key}) : super(key: key);

  @override
  State<ChargeModePage> createState() => _ChargeModePageState();
}

class _ChargeModePageState extends State<ChargeModePage>{
  late ChargeController _chargeController;

  @override
  void initState() {
    super.initState();
    _chargeController = ChargeController(UpdateChargerAvailability(ChargingService()),
        CreateChargingEvent(ChargingService()));
  }

  late Timer _timer;
  bool isRunning = false;

  double counter = 0.00;
  double volumeCharge = 0.00, priceCharge = 0.00;

  String formattedDateTimeStart = "/", formattedDateTimeEnd = "/", formattedDuration = "/";
  int globalUserID = 0;   // This is being outputted to the user so in the production version make it not be hardcoded or don't log it at all

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

  void onPressStart() {
    if (!isRunning) {
      startTimer();
      setState(() {
        isRunning = true;
      });
      _chargeController.updateChargerAvailability(1, true);
      DateTime now = DateTime.now();
      formattedDateTimeStart = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    }
    print('START button clicked');
  }

  void onPressStop() {
    if (isRunning) {
      stopTimer();

      DateTime now = DateTime.now();
      formattedDateTimeEnd = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);

      counter = counter/10;
      int unformattedDuration = counter.toInt();
      formattedDuration = DurationFormatter.formatCounterToDuration(unformattedDuration);

      volumeCharge = double.parse(((counter*2.361)/10).toStringAsExponential(3));
      priceCharge = double.parse(((counter*1.5)/10).toStringAsExponential(3));


      _chargeController.updateChargerAvailability(1, false);
      _chargeController.createChargingEvent(formattedDateTimeStart, formattedDateTimeEnd, formattedDuration, volumeCharge, priceCharge);
    }
    print('UserID: $globalUserID');
    print('Time charged: $counter seconds');
    print('Power: $volumeCharge');
    print('Price: $priceCharge');
    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      Navigator.pushReplacementNamed(context, 'startMenuRoute');
      return false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charge Mode'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.black87,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(height: 40),
              const Text(
                //'Welcome, ${widget.userName}', // Display the welcome message with the user's name
                'Welcome, Ivan Horvat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(child: Center(
                child: Column (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleButton(
                        label: 'START',
                        onClick: !isRunning ? () => onPressStart() : null,
                      ),
                      const SizedBox(height: 20),
                      CircleButton(
                        label: 'STOP',
                        onClick: isRunning ? () => onPressStop() : null,
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onClick;

  const CircleButton({super.key, required this.label, this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(30),
        backgroundColor: Colors.blue,
        minimumSize: const Size(200, 200),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}