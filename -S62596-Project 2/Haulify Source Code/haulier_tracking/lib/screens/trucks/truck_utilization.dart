/*
Author: Nuha Nordin
Project: Haulify
File: truck_utilization.dart.dart
*/
import 'package:flutter/material.dart';
import '../../utils/background.dart';
import '../home.dart';
import '../../screens/profile.dart';
import 'truck_registration.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TruckUtilizationScreen extends StatefulWidget {
  final String loggedInUsername;

  const TruckUtilizationScreen({Key? key, required this.loggedInUsername})
      : super(key: key);

  @override
  State<TruckUtilizationScreen> createState() => _TruckUtilizationScreen();
}

class _TruckUtilizationScreen extends State<TruckUtilizationScreen> {
  int _currentIndex = 2;

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
        break;
      case 3:
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

  Map<String, double> dataMap = {};
  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539)
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  void _loadTruckUtilizationData() async {
    try {
      final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.loggedInUsername}/trucks.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> truckData = json.decode(response.body);

        truckData.forEach((key, truck) {
          final use = truck['use'] ?? 'Other';
          final utilization =
              dataMap.containsKey(use) ? dataMap[use]! + 1 : 1.0;

          dataMap[use] = utilization;
        });

        setState(() {});
      } else {
        print(
            'Failed to load truck utilization data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading truck utilization data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTruckUtilizationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        key: const Key("background_key"),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Truck Utilization",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              dataMap.isEmpty
                  ? const Text(
                      "No data available",
                      style: TextStyle(fontSize: 16),
                    )
                  : PieChart(
                      dataMap: dataMap,
                      colorList: colorList,
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      centerText: "Use",
                      ringStrokeWidth: 24,
                      animationDuration: const Duration(seconds: 3),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValues: true,
                        showChartValuesOutside: true,
                        showChartValuesInPercentage: true,
                        showChartValueBackground: false,
                      ),
                      legendOptions: const LegendOptions(
                        showLegends: true,
                        legendShape: BoxShape.rectangle,
                        legendTextStyle: TextStyle(fontSize: 15),
                        legendPosition: LegendPosition.bottom,
                        showLegendsInRow: true,
                      ),
                      gradientList: gradientList,
                    ),
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
          ]),
    );
  }
}
