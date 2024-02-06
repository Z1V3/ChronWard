import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:core/utils/api_configuration.dart';
import 'package:core/models/user_model.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';

class AuthService {
  static Future<void> loginUser(BuildContext context, String email, String password) async {
    final String apiUrl = ApiConfig.apiUrl;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      int userID = jsonResponse['user']['userId'];
      UserModel user = UserModel(userID);
      await SharedHandlerUtil.saveUserID(userID);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      print('User ID: $userID');

      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Successful'),
        content: const Text('Welcome!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'userModePageRoute');
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));

      showDialog(context: context, builder: (context) => alertDialog);
    } else if (response.statusCode == 404) {
      // Failed login
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('User not found.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));

      showDialog(context: context, builder: (context) => alertDialog);
    } else if (response.statusCode == 401) {
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Wrong password.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));

      showDialog(context: context, builder: (context) => alertDialog);
    } else {
      // Failed login
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Unexpected error occurred.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));
      print('Error: ${response.statusCode}');
      showDialog(context: context, builder: (context) => alertDialog);
    }
  }
}
