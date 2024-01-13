// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously
/*
Author: Nuha Nordin
Project: Haulify
File: profile.dart
*/
import 'dart:convert';
import 'package:haulier_tracking/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:haulier_tracking/utils/background.dart';
import 'package:haulier_tracking/screens/home.dart';
import 'package:haulier_tracking/screens/trucks/truck_registration.dart';
import 'package:haulier_tracking/screens/trucks/truck_utilization.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import 'calendar.dart';

class ProfileScreen extends StatefulWidget {
  final String loggedInUsername;

  const ProfileScreen({Key? key, required this.loggedInUsername})
      : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;
  late Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    const url =
        'https://haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app/users.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final user = data.values.firstWhere(
          (user) => user['username'] == widget.loggedInUsername,
          orElse: () => {},
        );

        setState(() {
          userData = user;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(loggedInUsername: widget.loggedInUsername),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TruckRegistrationScreen(
              loggedInUsername: widget.loggedInUsername,
              onTruckRegistered: (Truck) {},
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TruckUtilizationScreen(
              loggedInUsername: widget.loggedInUsername,
            ),
          ),
        );
        break;
      case 3:
        break;
    }
  }

  void _editEmail() async {
    final TextEditingController emailController = TextEditingController();
    emailController.text = userData['email'];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Email'),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'New Email'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final url = Uri.https(
                  'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
                  'users.json',
                );

                try {
                  final response = await http.get(url);
                  final Map<String, dynamic> usersData =
                      json.decode(response.body);

                  final userKey = usersData.keys.firstWhere(
                    (key) =>
                        usersData[key]['username'] == widget.loggedInUsername,
                    orElse: () => '',
                  );

                  if (userKey != null) {
                    // update the email
                    final updateUrl = Uri.https(
                      'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
                      'users/$userKey.json',
                    );

                    await http.patch(
                      updateUrl,
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        'email': emailController.text,
                      }),
                    );

                    setState(() {
                      userData['email'] = emailController.text;
                    });
                    Navigator.of(context).pop();
                  } else {
                    print('User not found');
                  }
                } catch (error) {
                  print('Error: $error');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editPhone() async {
    final TextEditingController phoneController = TextEditingController();
    phoneController.text = userData['phone'] ?? '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'New Phone Number'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final url = Uri.https(
                  'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
                  'users.json',
                );

                try {
                  final response = await http.get(url);
                  final Map<String, dynamic> usersData =
                      json.decode(response.body);

                  final userKey = usersData.keys.firstWhere(
                    (key) =>
                        usersData[key]['username'] == widget.loggedInUsername,
                    orElse: () => '',
                  );

                  if (userKey != null) {
                    // Update the phone
                    final updateUrl = Uri.https(
                      'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
                      'users/$userKey.json',
                    );

                    await http.patch(
                      updateUrl,
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        'phone': phoneController.text,
                      }),
                    );

                    setState(() {
                      userData['phone'] = phoneController.text;
                    });
                    Navigator.of(context).pop();
                  } else {
                    print('User not found');
                  }
                } catch (error) {
                  print('Error: $error');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _changePassword() async {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Old Password'),
                ),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // validate old password
                if (userData['password'] == oldPasswordController.text) {
                  final url = Uri.https(
                    'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
                    'users.json',
                  );

                  try {
                    final response = await http.get(url);
                    final Map<String, dynamic> usersData =
                        json.decode(response.body);

                    final userKey = usersData.keys.firstWhere(
                      (key) =>
                          usersData[key]['username'] == widget.loggedInUsername,
                      orElse: () => '',
                    );

                    if (userKey != null) {
                      // Update the password
                      final updateUrl = Uri.https(
                        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
                        'users/$userKey.json',
                      );

                      await http.patch(
                        updateUrl,
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                          'password': newPasswordController.text,
                        }),
                      );

                      setState(() {
                        userData['password'] = newPasswordController.text;
                      });
                      Navigator.of(context).pop();
                    } else {
                      print('User not found');
                    }
                  } catch (error) {
                    print('Error: $error');
                  }
                } else {
                  print('Old password incorrect');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action is irreversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final usersUrl = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users.json',
      );

      try {
        final usersResponse = await http.get(usersUrl);
        final Map<String, dynamic> usersData = json.decode(usersResponse.body);

        // Find the user by username
        final userKey = usersData.keys.firstWhere(
          (key) => usersData[key]['username'] == widget.loggedInUsername,
          orElse: () => '',
        );

        if (userKey != null) {
          // Delete the user
          final deleteUserUrl = Uri.https(
            'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
            'users/$userKey.json',
          );

          await http.delete(deleteUserUrl);

          final userRecordsUrl = Uri.https(
            'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
            'users/${widget.loggedInUsername}.json',
          );

          await http.delete(userRecordsUrl);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          print('User not found in the users table');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Background(
        key: const Key("background_key"),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  "",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://static.thenounproject.com/png/4851855-200.png',
                  ),
                  backgroundColor: Color.fromARGB(255, 206, 200, 180),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(
                          loggedInUsername: widget.loggedInUsername),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 206, 200, 180),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(150, 30),
                ),
                child: const Text('View Calendar'),
              ),
              const SizedBox(height: 20),
              userData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 340,
                          height: 55,
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${userData['name']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${userData['email']}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editEmail();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 350,
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      userData['phone'] != null
                                          ? '${userData['phone']}'
                                          : 'No phone number',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _editPhone();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              TextButton(
                onPressed: () {
                  _changePassword();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 53, 115, 79),
                ),
                child: const Text('Change Password'),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 206, 200, 180),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(50, 50),
                    ),
                    child: const Icon(Icons.brightness_4),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 206, 200, 180),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: () {
                      _deleteAccount();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 230, 84, 84),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        elevation: 10.0,
        selectedItemColor: const Color.fromARGB(255, 53, 115, 79),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Truck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Utilization',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
