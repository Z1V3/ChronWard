import 'package:android/presentation/login_page.dart';
import 'package:core/handlers/nfc_handler.dart';
import 'package:core/models/user_model.dart';
import 'package:core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../domain/controllers/card_controller.dart';

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
  const StartMenu({super.key});

  @override
  _StartMenuState createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  bool isLoading = false;
  String? _result;
  late Timer _buttonVisibilityTimer;
  late CardController _cardController;

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
                Navigator.pushReplacement( // Use pushReplacement to replace the current route with the login page
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(Icons.login_rounded),
              iconSize: 45,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16), // Adjust the width for spacing
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/carstation.png',
                  fit: BoxFit.fitHeight,
                  height: 250,
                ),
                if (isLoading)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(29.0),
                          child: Icon(
                            Icons.credit_card,
                            size: 150,
                            color: Colors.black87,
                          ),
                        ),
                          CircularProgressIndicator(color: Colors.black87), // Show loading indicator if isLoading is true
                          SizedBox(height: 40), // Empty SizedBox if not loading
                        Text(
                          'Scan your card...',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                 else
                    CircleButton(
                      label: 'Charge Mode',
                      onClick: () async {
                        setState(() {
                          isLoading = true; // Show the bottom button when "Charge Mode" is pressed
                        });

                        _cardController = CardController();
                        NFCHandler.startNFCReading(
                              (hexIdentifier) async {
                            int userID = await _cardController.sendAuthenticateCard(hexIdentifier);
                            NFCHandler.stopNFCReading();
                            setState(() {
                              isLoading = false; // Update loading state when NFC reading is complete
                            });

                            if (!context.mounted) return;

                            UserModel userModel = UserModel(userID);
                            Provider.of<UserProvider>(context, listen: false).setUser(userModel);
                            if (userID > 0) {
                              Navigator.pushReplacementNamed(context, 'chargeModePageRoute');
                            }
                            else {
                              _showSnackbar(context, 'Card was not found!');
                            }
                          },
                              (errorMessage) {
                            setState(() {
                              isLoading = false; // Update loading state when NFC reading encounters an error
                            });
                            _showSnackbar(context, 'Card was not read successfully!');
                            debugPrint(
                                "Error occurred while reading NFC: $errorMessage");
                            // Handle the error
                          },
                        );
                      },
                    ),
                const SizedBox(height: 70),
              ],
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
          color: Colors.lightBlueAccent,
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