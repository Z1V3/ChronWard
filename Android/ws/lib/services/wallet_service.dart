import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ws/privateAddress.dart';

class WalletService {

  Future<double> fetchWallet(int userId) async {
    print('Fetching wallet');
    final url = 'http://${returnAddress()}:8080/api/user/getWalletByUserId/$userId';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    print(json);
    return json;
  }

  Future<void> updateWalletValue(int userId, double amount) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/user/updateWalletValue');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'wallet': amount,
        }),
      );

      if (response.statusCode == 200) {
        print('Request successful');
        print('Response: ${response.body}');
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending POST request: $e');
    }
  }

}