import 'package:core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:core/utils/api_configuration.dart';
import 'package:core/services/history_data_manager_service.dart';

class FetchHistoryService {
  static Future <void> fetchUserHistory (BuildContext context) async {
    final int? userId = Provider.of<UserProvider>(context, listen: false).user?.userID;
    print('Fetching history');
    final url = '${ApiConfig.userHistoryApi}$userId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    HistoryDataManager.updateHistoryList(List<Map<String, dynamic>>.from(json));

    print(json);
    print('Fetch charging history finished');
  }
}
