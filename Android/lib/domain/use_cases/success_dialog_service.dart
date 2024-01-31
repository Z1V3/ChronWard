import 'package:flutter/material.dart';

class DialogService {
  static void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('You have successfully registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'loginPageRoute');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
