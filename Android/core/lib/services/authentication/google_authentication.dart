import 'dart:convert';
import 'package:core/services/authentication/IAuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:core/utils/api_configuration.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication implements IAuthService {

  @override
  Future<void> signIn(BuildContext context, String? email,String? password) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      String? username = userCredential.user?.displayName.toString();
      SharedHandlerUtil.saveUserName(username!);

      if (userCredential.user != null) {
        String? idToken = googleAuth?.idToken;
        await sendIdTokenToBackend(idToken);
        await getUserId(idToken);
        Navigator.pushReplacementNamed(context, 'userModePageRoute');
      }

    } catch (error) {
      print('Error signing in with Google: $error');
    }

  }

  @override
  Future <void> signOut (BuildContext context) async{
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  static Future<void> sendIdTokenToBackend(String? idToken) async {
    final String backendApiUrl = ApiConfig.googleApi;

    try {
      final response = await http.post(
        Uri.parse(backendApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        print('ID token sent successfully');
      } else {
        print('Failed to send ID token. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error sending IdToken to backend: $error');
    }
  }

  static Future<void> getUserId(String? token) async {
    final String url = ApiConfig.googleApi;
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {'token': token};

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('user')) {
          final userResponse = responseData['user'];
          print(userResponse['userId'].toString());
          SharedHandlerUtil.saveUserID(userResponse['userId']);
          //Provider.of<UserProvider>(context, listen: false).setUser(user);
        } else {
          print('User data not found in response');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}