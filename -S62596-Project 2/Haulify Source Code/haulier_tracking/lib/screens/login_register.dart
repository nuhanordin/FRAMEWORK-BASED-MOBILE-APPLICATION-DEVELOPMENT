// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
/*
Author: Nuha Nordin
Project: Haulify
File: login_register.dart
*/
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/background.dart';
import 'home.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  _LoginSRegisterScreenState createState() => _LoginSRegisterScreenState();
}

class _LoginSRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loggedInUsername = "";
  bool isRegister = false;

  Future<Map<String, dynamic>> fetchDataFromFirebase(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) ?? {};
    } else {
      throw Exception('Failed to fetch data from Firebase');
    }
  }

  bool emailOrUsernameExists(Map<String, dynamic> existingData) {
    final String enteredEmail = emailController.text;
    final String enteredUsername = usernameController.text;

    return existingData.values.any((userData) =>
        userData['email'] == enteredEmail ||
        userData['username'] == enteredUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
      key: const Key("background_key"),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 300,
              child: Container(
                padding: const EdgeInsets.only(top: 100, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome ",
                          style: const TextStyle(
                            fontSize: 25,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: isRegister ? "to Haulify" : "Back!",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main Container
          // reference: Flutter tutorial | Beautiful login and sign up page UI, https://www.youtube.com/watch?v=v4nEjn6TOZ4
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            top: isRegister ? 160 : 200,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              height: isRegister ? 600 : 450,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRegister = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isRegister
                                        ? const Color.fromARGB(
                                            255, 156, 156, 139)
                                        : Colors.black),
                              ),
                              if (!isRegister)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color:
                                      const Color.fromARGB(255, 131, 170, 119),
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isRegister = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isRegister
                                        ? const Color.fromARGB(
                                            255, 156, 156, 139)
                                        : Colors.black),
                              ),
                              if (isRegister)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color:
                                      const Color.fromARGB(255, 131, 170, 119),
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isRegister) buildRegisterSection(),
                    if (!isRegister) buildLoginSection()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  bool obscurePassword = true;
  bool rememberMe = false;
  Container buildLoginSection() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        child: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value!;
                      });
                    },
                  ),
                  const Text('Remember Me'),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 206, 200, 180),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(350, 50),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isRegister = true;
                      });
                      buildRegisterSection();
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }

  Container buildRegisterSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10, left: 10),
          ),
          Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            child: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _registerUser,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              const Color.fromARGB(255, 206, 200, 180),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          minimumSize: const Size(350, 50),
                        ),
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isRegister = false;
                          });
                          buildLoginSection();
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 250.0),
                    ],
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  void _loginUser() async {
    final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> usersData = json.decode(response.body);

      bool isUserFound = false;

      for (var userId in usersData.keys) {
        if (usersData[userId]['username'] == usernameController.text &&
            usersData[userId]['password'] == passwordController.text) {
          // login successful
          isUserFound = true;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(loggedInUsername: loggedInUsername)),
          );
          break;
        }
      }

      if (!isUserFound) {
        // if not found
        _showSnackBar('Invalid username or password');
      } else {
        loggedInUsername = usernameController.text;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(loggedInUsername: loggedInUsername),
          ),
        );
      }
    } else {
      _showSnackBar('Error fetching user data');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https(
          'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
          'users.json');

      // check if already exist
      final existingData = await fetchDataFromFirebase(url);
      if (emailOrUsernameExists(existingData)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email or username already exists'),
          ),
        );
        return;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nameController.text,
          'email': emailController.text,
          'username': usernameController.text,
          'password': passwordController.text,
          'phone': null,
        }),
      );

      if (response.statusCode == 200) {
        // Registration successful
        // Store registered user data in global variable
        // RegisterScreen.registeredUserData = {
        // 'username': usernameController.text,
        // 'password': passwordController.text,
        // };

        setState(() {
          isRegister = false;
        });
        buildLoginSection();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error registering user'),
          ),
        );
        emailController.clear();
        usernameController.clear();
      }
    }
  }
}
