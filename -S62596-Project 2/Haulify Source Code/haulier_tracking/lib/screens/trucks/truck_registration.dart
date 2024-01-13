// ignore_for_file: library_private_types_in_public_api
/*
Author: Nuha Nordin
Project: Haulify
File: truck_registration.dart
*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:haulier_tracking/utils/background.dart';
import 'package:haulier_tracking/screens/home.dart';
import '../../models/truck_model.dart';
import '../../screens/profile.dart';
import 'truck_utilization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TruckRegistrationScreen extends StatefulWidget {
  final Function(Truck) onTruckRegistered;
  final String loggedInUsername;

  const TruckRegistrationScreen({
    super.key,
    required this.onTruckRegistered,
    required this.loggedInUsername,
  });

  @override
  _TruckRegistrationScreenState createState() =>
      _TruckRegistrationScreenState();
}

class _TruckRegistrationScreenState extends State<TruckRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController useController = TextEditingController();
  String _selectedUse = "-1";

  int _currentIndex = 1;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Home screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(loggedInUsername: widget.loggedInUsername),
          ),
        );
        break;
      case 1:
        // Navigate to Add Truck screen

        break;
      case 2:
        // Navigate to Utilization screen
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
        // Navigate to Profile screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(loggedInUsername: widget.loggedInUsername),
          ),
        );
        break;
    }
  }

  // Method to check if any text field is empty
  bool isEmpty() {
    return licensePlateController.text.isEmpty ||
        modelController.text.isEmpty ||
        capacityController.text.isEmpty ||
        _selectedUse == "-1";
  }

  String _generateRandomId() {
    // random character and two random digits
    // reference: Flutter - How To Generate Random Numbers (With Different Ranges), https://www.youtube.com/watch?v=hTKBFuw-xyo
    final random = Random();
    final randomChar =
        String.fromCharCode('A'.codeUnitAt(0) + random.nextInt(26));
    final randomDigits = '${random.nextInt(10)}${random.nextInt(10)}';

    final randomId = '$randomChar$randomDigits';

    return randomId;
  }

  void _registerTruck() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final truckId = _generateRandomId();

      final url = Uri.https(
          'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
          'users/${widget.loggedInUsername}/trucks.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': truckId,
          'licensePlate': licensePlateController.text,
          'model': modelController.text,
          'capacity': int.parse(capacityController.text),
          'use': _selectedUse,
          'scheduledDate': null,
          'scheduledTime': null,
          'origin': null,
          'destination': null,
          'movement': null,
        }),
      );

      if (response.statusCode == 200) {
        Truck newTruck = Truck(
          id: truckId,
          licensePlate: licensePlateController.text,
          model: modelController.text,
          capacity: int.parse(capacityController.text),
          use: _selectedUse,
          scheduledDate: null,
          scheduledTime: null,
          origin: null,
          destination: null,
          movement: null,
        );

        widget.onTruckRegistered(newTruck);

        // ignore: use_build_context_synchronously
        Navigator.pop(context, licensePlateController.text);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error registering the truck'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        key: const Key("background_key"),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register Truck',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  TextFormField(
                    controller: licensePlateController,
                    decoration: const InputDecoration(
                      labelText: 'License Plate',
                      prefixIcon: Icon(Icons.car_rental),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a license plate';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                      prefixIcon: Icon(Icons.card_membership),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a model';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: capacityController,
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
                      hintText: 'kg',
                      prefixIcon: Icon(Icons.scale),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a capacity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == "-1") {
                        return 'Please select use';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.shopping_basket),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "-1",
                        child: Text('Select Use'),
                      ),
                      DropdownMenuItem(
                        value: "Clothes",
                        child: Text('Clothes'),
                      ),
                      DropdownMenuItem(
                        value: "Foods & Beverages",
                        child: Text('Foods & Beverages'),
                      ),
                      DropdownMenuItem(
                        value: "Animal",
                        child: Text('Animal'),
                      ),
                      DropdownMenuItem(
                        value: "Electronics",
                        child: Text('Electronics'),
                      ),
                      DropdownMenuItem(
                        value: "Medicine",
                        child: Text('Medicine'),
                      ),
                      DropdownMenuItem(
                        value: "Vehicles",
                        child: Text('Vehicles'),
                      ),
                      DropdownMenuItem(
                        value: "Others",
                        child: Text('Others'),
                      ),
                    ],
                    value: _selectedUse,
                    onChanged: (value) {
                      setState(() {
                        _selectedUse = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: _registerTruck,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color.fromARGB(255, 206, 200, 180),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(350, 50),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
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
          ]),
    );
  }
}
