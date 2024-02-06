import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:core/utils/api_configuration.dart';
import 'package:core/services/success_dialog_service.dart';

class RegisterService {
  static Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registrationApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('User registered successfully!');
        DialogService.showSuccessDialog(context);
      } else {
        // Registration failed
        print('Registration failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during registration: $error');
    }
  }
}