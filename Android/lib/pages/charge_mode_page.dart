import 'package:flutter/material.dart';

class ChargeModePage extends StatelessWidget {
  const ChargeModePage({Key? key}) : super(key: key);

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
                // Add your START button click event logic here
                print('START button clicked');
              },
            ),
            const SizedBox(height: 20),
            CircleButton(
              label: 'STOP',
              onClick: () {
                // Add your STOP button click event logic here
                print('STOP button clicked');
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