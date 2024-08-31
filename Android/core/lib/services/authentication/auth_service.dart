/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../handlers/shared_handler.dart';
import '../../utils/api_configuration.dart';


class AuthServiceNew {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context, String? email,String? password) async {
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
        Navigator.pushReplacementNamed(context, 'userModePageRoute');
      }

    } catch (error) {
      print('Error signing in with Google: $error');
    }

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

  Future<void> signInWithFacebook(BuildContext context, String? email, String? password) async {
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
}
*/