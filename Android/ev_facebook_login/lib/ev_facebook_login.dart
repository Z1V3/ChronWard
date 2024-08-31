/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:core/utils/api_configuration.dart';
import 'package:core/interfaces/ILogin.dart';

class Login implements ILogin{
  @override
  Future<void> signIn(BuildContext context, String? email, String? password) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken!.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        final String? username = userCredential.user?.displayName.toString();
        SharedHandlerUtil.saveUserName(username!);

        if (userCredential.user != null) {
          final String? idToken = await userCredential.user?.getIdToken();
          await sendIdTokenToBackend(idToken);
          Navigator.pushReplacementNamed(context, 'userModePageRoute');
        }
      } else {
        print('Error signing in with Facebook: ${loginResult.message}');
      }
    } catch (error) {
      print('Error signing in with Facebook: $error');
    }
  }

  @override
  Future<void> sendIdTokenToBackend(String? idToken) async {
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

  @override
  Future<void> signOut (BuildContext context)async {
    await FacebookAuth.instance.logOut();
    FirebaseAuth.instance.signOut();
  }

  @override
  String getVendorName(){
    return 'facebook_ikona.png';
  }
}*/