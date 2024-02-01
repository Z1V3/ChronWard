import 'package:ws/services/charge_service.dart';

class UpdateChargerAvailability {
  final ChargeService _chargeService;

  UpdateChargerAvailability(this._chargeService);

  Future<void> execute(int chargerID, bool occupied) async {
    await _chargeService.sendChargerOccupation(chargerID, occupied);
  }
}
