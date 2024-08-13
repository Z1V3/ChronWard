// user_model.dart
class UserModel {
  final int userID;
  final String role;

  UserModel(this.userID, this.role);
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