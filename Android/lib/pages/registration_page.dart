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
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.2),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0)
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
                                borderRadius: BorderRadius.circular(5), // Set border radius to 0 for squared corners
                              ),
                            ),
                            child: const Text(
                              'Create account',
                              style: TextStyle(
                                  color: Colors.black
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
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Set border radius to 0 for squared corners
                              ),
                            ),
                            child: const Text('Log In',
                              style: TextStyle(
                                  color: Colors.black
                              ),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                const Row(
                  children: [
                    SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        'First name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        'Last name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'First name',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Last name',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                const Row(
                  children: [
                    SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15.0),
                const Row(
                  children: [
                    SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'I agree to the terms and conditions',
                      style: TextStyle(
                        fontSize: 16,
                        color: isChecked ? Colors.black : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String name = _firstNameController.text;
                            String surname = _lastNameController.text;
                            String email = _emailController.text;
                            String password = _passwordController.text;

                            print(
                                'Name: $name\nLast name: $surname\nEmail: $email\nPassword: $password');
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
