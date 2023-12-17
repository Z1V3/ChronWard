// shared_preferences_util.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedHandlerUtil {
  static const String keyUserID = 'userID';

  static Future<void> saveUserID(int userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserID, userID);
  }

  static Future<int?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserID);
  }
}