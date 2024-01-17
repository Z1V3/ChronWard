import 'package:ws/services/charging_service.dart';

class CreateChargingEvent {
  final ChargingService _chargingService;

  CreateChargingEvent(this._chargingService);

  Future<void> execute(String startTime, String endTime, String chargeTime, double volume, double price) async {
    await _chargingService.sendCreateEvent(startTime, endTime, chargeTime, volume, price);
  }
}
