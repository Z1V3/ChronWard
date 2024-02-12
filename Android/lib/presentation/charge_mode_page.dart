import 'dart:async';
import 'package:android/domain/use_cases/create_charging_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ws/models/charging_data.dart';
import 'package:core/utils/duration_formatter.dart';
import 'package:android/domain/controllers/charger_controller.dart';
import 'package:ws/services/charge_service.dart';
import 'package:android/domain/use_cases/update_charger_availability.dart';

class ChargeModePage extends StatefulWidget {
  const ChargeModePage({Key? key}) : super(key: key);

  @override
  State<ChargeModePage> createState() => _ChargeModePageState();
}

class _ChargeModePageState extends State<ChargeModePage>{
  late ChargeController _chargeController;
  final ChargingData _chargingData = ChargingData(startTime: "/", endTime: "/", chargeTime: "/", volume: 0, price: 0, userID: 0, chargerID: 0);

  late Timer _timer;
  bool isRunning = false;
  double counter = 0.00;
  double loadingProgress = 0.0; // Added loading progress

  bool startButtonVisible = true;
  bool stopButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _chargeController = ChargeController(UpdateChargerAvailability(ChargeService()),
        CreateChargingEvent(ChargeService()));
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
        loadingProgress = counter / 300; // 30 seconds -> 300 ticks
        // Update charging session information while running
        _updateChargingData();
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
        startButtonVisible = false;
        stopButtonVisible = true;
      });
      _chargeController.updateChargerAvailability(1, true);
      DateTime now = DateTime.now();
      _chargingData.startTime = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    }
    debugPrint('START button clicked');
  }

  void onPressStop(BuildContext context) {
    if (isRunning) {
      stopTimer();

      DateTime now = DateTime.now();
      _chargingData.endTime = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);

      counter = counter/10;
      int unformattedDuration = counter.toInt();

      _chargingData.chargeTime = DurationFormatter.formatCounterToDuration(unformattedDuration);
      _chargingData.volume = _calculateVolume(counter);
      _chargingData.price = _calculatePrice(counter);
      _chargingData.userID = 1;
      _chargingData.chargerID = 1;

      _chargeController.updateChargerAvailability(1, false);
      _chargeController.createChargingEvent(_chargingData.startTime, _chargingData.endTime, _chargingData.chargeTime, _chargingData.volume, _chargingData.price);

      // Show pop-up message with charging data
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Charging Session Ended'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('UserID: ${_chargingData.userID}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift', // or any other desired font
                  ),
                ),
                Text('Time charged: ${_chargingData.chargeTime}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift', // or any other desired font
                  ),
                ),
                Text('Power: ${(_chargingData.volume).toStringAsFixed(3)} kWh',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift', // or any other desired font
                  ),
                ),
                Text('Price: ${(_chargingData.price).toStringAsFixed(3)} EUR',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift', // or any other desired font
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    setState(() {
      counter = 0;
      loadingProgress = 0;
      startButtonVisible = true;
      stopButtonVisible = false;
    });
  }
  // Update charging data information
  void _updateChargingData() {
    _chargingData.volume = _calculateVolume(counter);
    _chargingData.price = _calculatePrice(counter);
  }

  // Calculate volume
  double _calculateVolume(double counter) {
    return double.parse(((counter * 2.361) / 10).toStringAsExponential(3));
  }

  // Calculate price
  double _calculatePrice(double counter) {
    return double.parse(((counter * 1.5) / 10).toStringAsExponential(3));
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
        backgroundColor: Colors.white,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.blueAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: Column (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display charging session information
                        isRunning ?
                        Column(
                          children: [
                            Text(
                              'Time Elapsed: ${Duration(milliseconds: (counter * 100).toInt()).inMinutes}:${Duration(milliseconds: (counter * 100).toInt()).inSeconds.remainder(60)} seconds',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Power: ${(_chargingData.volume / 10).toStringAsFixed(3)} kWh',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Price: ${(_chargingData.price / 10).toStringAsFixed(3)} EUR',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Container(
                                height: 20,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[300],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10), // Rounded corners for the clip
                                  child: LinearProgressIndicator(
                                    value: loadingProgress,
                                    backgroundColor: Colors.transparent,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) :
                        const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        startButtonVisible ?
                        CircleButton(
                          color: Colors.yellow,
                          icon: Icons.lightbulb,
                          breathing: false,
                          onClick: !isRunning ? () => onPressStart() : null,
                        ) :
                        const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        stopButtonVisible ?
                        CircleButton(
                          color: Colors.redAccent,
                          icon: Icons.stop_rounded,
                          breathing: true,
                          onClick: isRunning ? () => onPressStop(context) : null,
                        ) :
                        const SizedBox.shrink(),
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
class CircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onClick;
  final Color color;
  final bool breathing; // Added boolean to control breathing effect

  const CircleButton({Key? key, required this.icon, required this.color, required this.breathing, this.onClick}) : super(key: key);

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
    if (widget.breathing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant CircleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breathing && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.breathing && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.breathing ? _animation.value : 1.0, // Apply scale only when breathing
          child: ElevatedButton(
            onPressed: widget.onClick,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(30),
              backgroundColor: widget.color,
              minimumSize: const Size(200, 200),
              shadowColor: widget.color.withOpacity(0.5), // Adding a shadow effect
              elevation: 10, // Adding elevation for a 3D effect
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.yellow.withOpacity(0.8), // Lighter yellow at the center
                        Colors.orange.withOpacity(0.9), // Darker yellow at the edges
                      ],
                      stops: const [0.4, 1],
                    ),
                  ),
                ),
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 60,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
