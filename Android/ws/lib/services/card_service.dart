import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ws/privateAddress.dart';
import 'package:core/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CardService {
  Future<void> sendAddNewCard(String cardValue) async {
    try {
      final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/card/addNewCard');
      //int userID = Provider.of<UserProvider>(context, listen: false).user?.userID ?? 0;

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UserID': 1,
          'Value': cardValue,
        }),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending API request: $e');
    }
  }
}
