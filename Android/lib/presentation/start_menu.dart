import 'package:android/presentation/charge_mode_page.dart';
import 'package:android/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: StartMenu(),
    );
  }
}

class StartMenu extends StatefulWidget {
  const StartMenu({Key? key}) : super(key: key);

  @override
  _StartMenuState createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  bool isButtonClicked = false;
  bool isChargeModeActive = false;
  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  String? _result;
  late Timer _buttonVisibilityTimer;

  void showTextForLimitedTime() {
    setState(() {
      isButtonClicked = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isButtonClicked = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _buttonVisibilityTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        isChargeModeActive = false; // Hide the bottom button after 5 seconds
      });
      _buttonVisibilityTimer.cancel(); // Cancel the timer after hiding the button
    });
  }

  @override
  void dispose() {
    _buttonVisibilityTimer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _availability = availability;
    });
  }

  // Function to navigate to a new screen
  Future<void> _navigateToNewScreen(BuildContext context) async {
    //await Future.delayed(Duration(seconds: 2)); // Simulating an async operation

    // Navigating to a new screen using push
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChargeModePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          SizedBox(
            width: 56, // Define the width of the button
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.login_rounded),
              iconSize: 50, // Increase the icon size
            ),
          ),
          const SizedBox(width: 16), // Adjust the width for spacing
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black87,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Image.asset(
                    'assets/carstation.png',
                    fit: BoxFit.fitHeight,
                    height: 250,
                  ),
                ),
                CircleButton(
                  label: 'Charge Mode',
                  onClick: () async {
                    setState(() {
                      isChargeModeActive = true; // Show the bottom button when "Charge Mode" is pressed
                    });
                    showTextForLimitedTime();

                    try {
                      NFCTag tag = await FlutterNfcKit.poll();
                      setState(() {
                        _tag = tag;
                      });
                      await FlutterNfcKit.setIosAlertMessage(
                          "Working on it...");
                      if (tag.standard == "ISO 14443-4 (Type B)") {
                        String result1 =
                        await FlutterNfcKit.transceive("00B0950000");
                        String result2 = await FlutterNfcKit.transceive(
                            "00A4040009A00000000386980701");
                        setState(() {
                          _result = '1: $result1\n2: $result2\n';
                        });
                      } else if (tag.type == NFCTagType.iso18092) {
                        String result1 =
                        await FlutterNfcKit.transceive("060080080100");
                        setState(() {
                          _result = '1: $result1\n';
                        });
                      } else if (tag.ndefAvailable ?? false) {
                        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
                        var ndefString = '';
                        for (int i = 0; i < ndefRecords.length; i++) {
                          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
                        }
                        setState(() {
                          _result = ndefString;
                        });
                      } else if (tag.type == NFCTagType.webusb) {
                        await FlutterNfcKit.transceive(
                            "00A4040006D27600012401");
                      }

                      await _navigateToNewScreen(context);
                    } catch (e) {
                      setState(() {
                        _result = 'error: $e';
                      });
                    }

                    await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
                  },
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: AnimatedOpacity(
              opacity: isButtonClicked ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Please scan Your RFID card to enable charging',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isChargeModeActive, // Control visibility based on button activation
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChargeModePage()),
                    );// Action when the bottom button is pressed
                  },
                  child: const Text('Next page'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final VoidCallback onClick;

  const CircleButton({super.key, required this.label, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 90),
        margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
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