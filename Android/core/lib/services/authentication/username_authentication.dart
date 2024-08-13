import 'dart:convert';
import 'package:core/services/authentication/IAuthService.dart';
import 'package:http/http.dart' as http;
import 'package:core/utils/api_configuration.dart';
import 'package:core/models/user_model.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';

class AuthService implements IAuthService{
  @override
  Future<void> signIn(BuildContext context, String? email, String? password) async {
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
      String username = jsonResponse['user']['username'];
      String role = jsonResponse['user']['role'];

      UserModel user = UserModel(userID,role);
      await SharedHandlerUtil.saveUserID(userID);
      await SharedHandlerUtil.saveUserName(username);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      print('User ID: $userID');

      Navigator.pushReplacementNamed(
          context, 'userModePageRoute');

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
  @override
  Future <void> signOut (BuildContext context) async{
    SharedHandlerUtil.setUserNull();
  }
}
