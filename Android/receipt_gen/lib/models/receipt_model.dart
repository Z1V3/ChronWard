import 'package:receipt_gen/interfaces/receipt.dart';

class ChargeReceipt implements IReceipt {
  final int _id;
  final double _price;
  final String _startTime;
  final String _timeOfIssue;
  final String _chargeTime;
  final double _pricePerKwh;
  final double _volume;

  ChargeReceipt({
    required id,
    required price,
    required startTime,
    required timeOfIssue,
    required chargeTime,
    required pricePerKwh,
    required volume,
  }) : _id = id,
        _price = price,
        _startTime = startTime,
        _timeOfIssue = timeOfIssue,
        _chargeTime = chargeTime,
        _pricePerKwh = pricePerKwh,
        _volume = volume;


  @override
  int get id => _id;
  @override
  double get price => _price;
  @override
  String get startTime => _startTime;
  @override
  String get timeOfIssue => _timeOfIssue;
  @override
  String get chargeTime => _chargeTime;
  @override
  double get pricePerKwh => _pricePerKwh;
  @override
  double get volume => _volume;


}