import 'dart:convert';
import 'package:android/pages/user_mode_interface.dart';
import 'package:android/providers/user_provider.dart';
import 'package:android/models/user_model.dart';
import 'package:android/handlers/shared_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:android/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:android/privateAddress.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

final _formKeyLogin = GlobalKey<FormState>();

class ApiConfig {
  static String apiUrl = 'http://${returnAddress()}:8080/api/user/login';

  static void setApiUrl(String newUrl) {
    apiUrl = newUrl;
  }
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String apiUrl = ApiConfig.apiUrl;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {

      Map<String, dynamic> jsonResponse = json.decode(response.body);

      int userID = jsonResponse['user']['userId'];
      UserModel user = UserModel(userID);
      await SharedHandlerUtil.saveUserID(userID);
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      print('User ID: $userID');

      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Successful'),
        content: const Text('Welcome!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'myHomePageRoute');

            },
            child: const Text('OK'),
          ),
        ],);

      Future.delayed(const Duration(seconds: 1));

      showDialog(context: context, builder: (context) => alertDialog);
    } else if (response.statusCode == 404) {
      // Failed login
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('User not found.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));

      showDialog(context: context, builder: (context) => alertDialog);
    } else if (response.statusCode == 401) {
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Wrong password.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));

      showDialog(context: context, builder: (context) => alertDialog);
    }else {
      // Failed login
      AlertDialog alertDialog = AlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Unexpected error occurred.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );

      Future.delayed(const Duration(seconds: 1));
      print('Error: ${response.statusCode}');
      showDialog(context: context, builder: (context) => alertDialog);
    }
}
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      Navigator.pushReplacementNamed(context, 'startMenuRoute');
      return false;
    }
    bool isLoginPage = ModalRoute.of(context)?.settings.name == '/login';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: const Text(
          'Please login to continue',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          color: Colors.lightBlue[100],
          child: SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/skyline.png',
                      height: 200,
                      width: 600,
                      fit: BoxFit.fitWidth,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKeyLogin,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.2),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const RegistrationPage()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.lightBlue[100],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: const Text(
                                          'Create account',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          backgroundColor: isLoginPage ? Colors.lightBlue[100] : Colors.lightBlue[300],
                                        ),
                                        child: const Text('Log In', style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[200],
                                    ),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        labelText: 'Email',

                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey[200],
                                    ),
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: ()  {
                                            loginUser();
                                            //setUserID();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.lightBlue[300]),
                                          ),
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/ikonica.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 5,),
                                      ElevatedButton(
                                        onPressed: () {
                                          signInWithGoogle();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.lightBlue[300])
                                        ),
                                        child: const Text('Sign in', style: TextStyle(
                                          color: Colors.white
                                        ),),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  signInWithGoogle() async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,

    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print (userCredential.user?.displayName);

    if (userCredential.user != null) {
      Navigator.pushReplacementNamed(context, 'myHomePageRoute');
    }
  }
}
