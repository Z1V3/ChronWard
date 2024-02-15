import 'package:android/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:android/domain/use_cases/register_user.dart';

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
  final _formKeyRegistration = GlobalKey<FormState>();
  bool isChecked = false;

  Future<void> registerUser() async {
    if (_formKeyRegistration.currentState!.validate()) {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      await RegisterService.registerUser(username: username,
          email: email,
          password: password,
          context: context
      );
    }


    @override
    void initState() {
      super.initState();
      _confirmPasswordController.text = '';
    }
  }

    @override
    Widget build(BuildContext context) {
      bool isLoginPage = ModalRoute
          .of(context)
          ?.settings
          .name == '/register';
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'startMenuRoute');
            },
          ),
        ),
        body:

        Container(
          color: Colors.lightBlue[100],
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Image.asset('assets/skyline.png',
                height: 150,
                width: 600,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKeyRegistration,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 0.2),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0.5,
                              vertical: 0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),

                                    backgroundColor: isLoginPage ? Colors
                                        .lightBlue[100] : Colors.lightBlue[300],
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
                                    Navigator.pushReplacementNamed(context, 'loginPageRoute');
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
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                            // Regular expression for email validation
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email address',
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0),
                          ),
                          obscureText: true,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ), const SizedBox(height: 15.0),
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0),
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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlue[300]),
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

