class ChargingData {
  String startTime;
  String endTime;
  String chargeTime;
  double volume;
  double price;
  int userID;
  int chargerID;

  ChargingData({
    required this.startTime,
    required this.endTime,
    required this.chargeTime,
    required this.volume,
    required this.price,
    required this.userID,
    required this.chargerID,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'chargeTime': chargeTime,
      'volume': volume,
      'price': price,
      'userID': userID,
      'chargerID': chargerID,
    };
  }
}