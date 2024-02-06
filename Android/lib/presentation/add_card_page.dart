import 'package:android/presentation/widgets/drawer_widget.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:android/presentation/widgets/drawer_widget.dart';
import 'package:core/handlers/nfc_handler.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key? key}) : super(key: key);

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {

  @override
  void initState() {
    super.initState();

    NFCHandler.startNFCReading();
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
      drawer: const DrawerWidget(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.black87,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Please scan your card...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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

  const CircleButton({Key? key, required this.label, this.onClick}) : super(key: key);

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
