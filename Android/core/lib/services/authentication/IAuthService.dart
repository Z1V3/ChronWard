import 'package:flutter/widgets.dart';

abstract class IAuthService {
  Future<void> signIn(BuildContext context,String? email,String? password);
  Future<void> signOut(BuildContext context);
}