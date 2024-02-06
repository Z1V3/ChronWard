class HistoryDataManager {
  static List<Map<String, dynamic>> chargingHistoryList = [];

  static void updateHistoryList(List<Map<String, dynamic>> newData) {
    chargingHistoryList.clear();
    chargingHistoryList.addAll(newData);
  }
}
