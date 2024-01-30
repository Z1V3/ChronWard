import 'package:ws/privateAddress.dart';


class ApiConfig {
  static String apiUrl = 'http://${returnAddress()}:8080/api/user/login';
  static String googleApi = 'http://${returnAddress()}:8080/api/user/google_login';
  static String userHistoryApi = 'http://${returnAddress()}:8080/api/event/getEventsByUserID/';
  static String registrationApiUrl = 'http://${returnAddress()}:8080/api/user/register';

  static void setApiUrl(String newUrl) {
    apiUrl = newUrl;
  }
}