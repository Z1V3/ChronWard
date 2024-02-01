import 'package:ws/services/charge_service.dart';

class CreateChargingEvent {
  final ChargeService _chargeService;

  CreateChargingEvent(this._chargeService);

  Future<void> execute(String startTime, String endTime, String chargeTime, double volume, double price) async {
    await _chargeService.sendCreateEvent(startTime, endTime, chargeTime, volume, price);
  }
}
