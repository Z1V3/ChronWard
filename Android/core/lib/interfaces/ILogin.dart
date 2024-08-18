import 'package:flutter/widgets.dart';

abstract class ILogin {
  Future<void> signIn(BuildContext context,String? email,String? password);
  Future<void> sendIdTokenToBackend(String? idToken);
  Future<void> signOut(BuildContext context);
  String getVendorName();
}