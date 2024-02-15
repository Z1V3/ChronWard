import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignOutService {
  static Future<void> signOutWithGoogle (BuildContext context) async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }
}