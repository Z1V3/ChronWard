import 'package:android/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:android/pages/login_page.dart';
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isChecked = false;

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

      ListView(
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
                                print('Button 1 pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),

                                backgroundColor: isLoginPage ? Colors.white : Colors.grey[300],
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
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'First name',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[200],
                          ),
                          child: TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Last name',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 18),
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
                      decoration: InputDecoration(
                        labelText: 'Email adress',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 18),
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
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 18),
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
                      decoration: InputDecoration(
                        labelText: 'Confirm your password',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 18), // Adjust the font size here
                    ),
                  ),

                  const SizedBox(height: 32.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKeyRegistration.currentState!.validate()) {
                              String name = _firstNameController.text;
                              String surname = _lastNameController.text;
                              String email = _emailController.text;
                              String password = _passwordController.text;

                              print(
                                  'Name: $name\nLast name: $surname\nEmail: $email\nPassword: $password');
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.indigo),
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
    );
  }
}
