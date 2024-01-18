import 'package:ws/services/charging_service.dart';

class UpdateChargerAvailability {
  final ChargingService _chargingService;

  UpdateChargerAvailability(this._chargingService);

  Future<void> execute(int chargerID, bool occupied) async {
    await _chargingService.sendChargerOccupation(chargerID, occupied);
  }
}
