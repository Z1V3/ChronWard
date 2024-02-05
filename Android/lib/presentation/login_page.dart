import 'package:android/presentation/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:core/services/authentication/username_authentication.dart';
import 'package:core/services/authentication/google_log_in_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

final _formKeyLogin = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    AuthService.loginUser(context, _emailController.text, _passwordController.text);
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
      resizeToAvoidBottomInset: false,
      body:Container(
        color: Colors.lightBlue[100],

          child: Expanded(
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
                                          GoogleSignInService.signInWithGoogle(context);
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
    );
  }
}

