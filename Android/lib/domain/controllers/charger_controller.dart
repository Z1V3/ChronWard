import 'package:android/domain/use_cases/update_charger_availability.dart';
import 'package:android/domain/use_cases/create_charging_event.dart';
import 'dart:async';

class ChargeController {
  final UpdateChargerAvailability _updateChargerAvailability;
  final CreateChargingEvent _createChargingEvent;

  ChargeController(this._updateChargerAvailability, this._createChargingEvent);

  Future<void> updateChargerAvailability(int chargerID, bool occupied) async {
    await _updateChargerAvailability.execute(chargerID, occupied);
  }

  Future<void> createChargingEvent(String startTime, String endTime, String chargeTime, double volume, double price, int userID) async {
    await _createChargingEvent.execute(startTime, endTime, chargeTime, volume, price, userID);
  }

}
