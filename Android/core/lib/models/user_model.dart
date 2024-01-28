// user_model.dart
class UserModel {
  final int userID;

  UserModel(this.userID);
}

class User {
  final int uid;
  final String email;
  final String password;

  User ({
    required this.uid,
    required this.email,
    required this.password,
  });
}