import 'package:flutter/material.dart';

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

class StartMenu extends StatelessWidget {
  const StartMenu({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Container(
        child: Stack(
          children: [
            Container(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'chargeModePageRoute');
                  },
                  child: Image.asset(
                    'assets/start_icon.png',
                    width: 300,
                    height: 300,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'registrationRoute');
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[300],
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),

                ),
                child: const Text('Login', style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}