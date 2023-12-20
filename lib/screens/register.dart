import 'dart:convert';
import 'package:bookhaven_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password1Controller = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        body: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Color(0xFFFFC436),
          ),
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Book Haven Mobile",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              TextField(
                controller: _fullnameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _password1Controller,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _password2Controller,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String fullname = _fullnameController.text;
                  String email = _emailController.text;
                  String password1 = _password1Controller.text;
                  String password2 = _password2Controller.text;

                  // Navigator.pop(context);
                  final response = await request.postJson(
                      "https://bookhaven-k6-tk.pbp.cs.ui.ac.id/auth/register/",
                      jsonEncode(<String, String>{
                        'username': username,
                        'fullname': fullname,
                        'email': email,
                        'password1': password1,
                        'password2': password2,
                      }));
                  print(response);
                  if (response['status'] == true) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('Register succesful.'),
                        ),
                      );
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                              'Register failed, Please fix your username or password'),
                        ),
                      );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(100, 50),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text(
                  'Already have an account? Login here.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    ));
  }
}
