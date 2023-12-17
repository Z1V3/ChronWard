import 'package:android/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:android/privateAddress.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isChecked = false;

  Future<void> registerUser() async {
    String registrationApiUrl = 'http://${returnAddress()}:8080/api/user/register';

    if (_formKeyRegistration.currentState!.validate()) {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        final response = await http.post(
          Uri.parse(registrationApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username' : _usernameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          print('User registered successfully!');
          _showSuccessDialog();
        } else {
          // Registration failed
          print('Registration failed. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error during registration: $error');
      }
    }
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('You have successfully registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'registrationRoute');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  final _formKeyRegistration = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _confirmPasswordController.text = '';
  }

  @override
  Widget build(BuildContext context) {

    bool isLoginPage = ModalRoute.of(context)?.settings.name == '/register';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[100],
        title: const Text(
          'Sign up to EV Charge App',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:

      Container(
        color: Colors.lightBlue[100],
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              child:
              Image.asset('assets/skyline.png',
                height: 150,
                width: 600,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKeyRegistration,
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
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),

                                  backgroundColor: isLoginPage ? Colors.lightBlue[100] : Colors.lightBlue[300],
                                ),
                                child: const Text(
                                  'Create account',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      children: [

                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[200],
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              keyboardType: TextInputType.text,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Email adress',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        obscureText: true,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),const SizedBox(height: 15.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[200],
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Confirm your password',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                        obscureText: true,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),

                    const SizedBox(height: 32.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              registerUser();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.lightBlue[300]),
                            ),
                            child: const Text('Register',
                              style: TextStyle(
                                  color: Colors.white
                              ),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
