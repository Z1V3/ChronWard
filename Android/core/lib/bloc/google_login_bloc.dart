import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:core/utils/api_configuration.dart';
import 'package:core/handlers/shared_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GoogleSignInService {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (googleUser == null || googleAuth == null) {
        // Handle the case where the user canceled the Google Sign-In
        Fluttertoast.showToast(
          msg: 'Google Sign-In canceled',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
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