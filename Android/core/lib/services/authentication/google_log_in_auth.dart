import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:core/utils/api_configuration.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:core/providers/user_provider.dart';
import 'package:core/models/user_model.dart';

class GoogleSignInService {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      String? username = userCredential.user?.displayName.toString();
      int userID = int.parse(userCredential.user?.uid ?? '0');
      UserModel user = UserModel(userID);
      await SharedHandlerUtil.saveUserID(userID);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
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
}