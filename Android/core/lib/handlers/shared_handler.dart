// shared_preferences_util.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedHandlerUtil {
  static const String keyUserID = 'userID';
  static const String username = 'userName';

  static Future<void> saveUserID(int userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyUserID, userID);
  }

  static Future<int?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserID);
  }
  static Future<void> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(username, userName);
  }
  static Future<String?> getSavedUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(username);
  }
}