import '../privateAddress.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/charging_data.dart';

class ChargeService {
  Future<void> sendChargerOccupation(int chargerID, bool occupied) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/charger/updateChargerAvailability');

    try {

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'chargerID': chargerID,
          'occupied': occupied,
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

  Future<void> sendCreateEvent(String startTime, String endTime, String chargeTime, double volume, double price, int userID) async {
    final Uri uri = Uri.parse('http://${returnAddress()}:8080/api/event/createEvent');

    try {
      ChargingData chargingData = ChargingData(
        startTime: startTime,
        endTime: endTime,
        chargeTime: chargeTime,
        volume: volume,
        price: price,
        userID: userID,
        chargerID: 2,
      );

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(chargingData.toJson()),
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
