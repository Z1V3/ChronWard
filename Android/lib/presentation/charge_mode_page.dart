import 'dart:async';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';
import 'package:android/domain/use_cases/create_charging_event.dart';
import 'package:core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

class _ChargeModePageState extends State<ChargeModePage> {
  late ChargeController _chargeController;
  final ChargingData _chargingData = ChargingData(
      startTime: "/",
      endTime: "/",
      chargeTime: "/",
      volume: 0,
      price: 0,
      userID: 0,
      chargerID: 0);

  late Timer _timer;
  bool isRunning = false;
  double counter = 0.00;
  double loadingProgress = 0.0;

  bool startButtonVisible = true;
  bool stopButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _chargeController = ChargeController(
        UpdateChargerAvailability(ChargeService()),
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
        loadingProgress = counter / 1200; // 30 seconds -> 300 ticks
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
      _chargingData.startTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    }
    debugPrint('START button clicked');
  }

  void onPressStop(BuildContext context) {
    if (isRunning) {
      stopTimer();

      DateTime now = DateTime.now();
      _chargingData.endTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);

      counter = counter / 10;
      int unformattedDuration = counter.toInt();

      _chargingData.chargeTime =
          DurationFormatter.formatCounterToDuration(unformattedDuration);
      _chargingData.volume = _calculateVolume(counter);
      _chargingData.price = _calculatePrice(counter);
      _chargingData.userID = Provider.of<UserProvider>(context, listen: false).user?.userID ?? 0;
      _chargingData.chargerID = 1;

      _chargeController.updateChargerAvailability(1, false);
      _chargeController.createChargingEvent(
          _chargingData.startTime,
          _chargingData.endTime,
          _chargingData.chargeTime,
          _chargingData.volume,
          _chargingData.price,
          _chargingData.userID);

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
                Text(
                  'User number: ${_chargingData.userID}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift',
                  ),
                ),
                Text(
                  'Time charged: ${_chargingData.chargeTime}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift',
                  ),
                ),
                Text(
                  'Power: ${(_chargingData.volume).toStringAsFixed(3)} kWh',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift',
                  ),
                ),
                Text(
                  'Price: ${(_chargingData.price).toStringAsFixed(3)} EUR',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Bahnschrift',
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

  void _updateChargingData() {
    _chargingData.volume = _calculateVolume(counter);
    _chargingData.price = _calculatePrice(counter);
  }

  double _calculateVolume(double counter) {
    return double.parse(((counter * 2.361) / 10).toStringAsExponential(3));
  }

  double _calculatePrice(double counter) {
    return double.parse(((counter * 1.5) / 10).toStringAsExponential(3));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Charge Mode',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0, // Removes the shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'startMenuRoute');
          },
        ),
      ),
      body: PopScope(
        child: Container(
          color: Colors.white70,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isRunning
                            ? Column(
                          children: [
                            Column(
                              children: [
                                // Time Elapsed
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.access_time,
                                        color: Colors.blue, size: 54),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Time (min):',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${Duration(milliseconds: (counter * 100).toInt()).inMinutes}:${Duration(milliseconds: (counter * 100).toInt()).inSeconds.remainder(60)}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Power
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.flash_on,
                                        color: Colors.yellow, size: 54),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Power:',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${(_chargingData.volume / 10).toStringAsFixed(3)} kWh',
                                      style: const TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Price
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.attach_money,
                                        color: Colors.green, size: 54),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Price:',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${(_chargingData.price / 10).toStringAsFixed(3)} EUR',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Container(
                                height: 20,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  color: Colors.grey[300],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners for the clip
                                  child: LinearProgressIndicator(
                                    value: loadingProgress,
                                    backgroundColor:
                                    Colors.transparent,
                                    valueColor:
                                    const AlwaysStoppedAnimation<
                                        Color>(Colors.greenAccent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                            : const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Touch sun to charge',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        startButtonVisible
                            ? GestureDetector(
                          onTap: !isRunning ? () => onPressStart() : null,
                          child: Image.asset(
                            'assets/start_icon.png',
                            width: 330,
                            height: 330,
                          ),
                        )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        stopButtonVisible
                            ? CircleButton(
                          color: Colors.redAccent,
                          icon: Icons.stop_rounded,
                          breathing: true,
                          onClick:
                          isRunning ? () => onPressStop(context) : null,
                        )
                            : const SizedBox.shrink(),
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
  final bool breathing;

  const CircleButton(
      {Key? key,
        required this.icon,
        required this.color,
        required this.breathing,
        this.onClick})
      : super(key: key);

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
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
          scale: widget.breathing ? _animation.value : 1.0,
          child: ElevatedButton(
            onPressed: widget.onClick,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(30),
              backgroundColor: widget.color,
              minimumSize: const Size(200, 200),
              shadowColor: widget.color.withOpacity(0.5),
              elevation: 10,
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
                        Colors.yellow.withOpacity(0.8),
                        Colors.orange.withOpacity(0.9),
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
