// ignore_for_file: library_private_types_in_public_api
/*
Author: Nuha Nordin
Project: Haulify
File: calendar.dart
*/
import 'package:flutter/material.dart';
import '../utils/background.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scroll_snap_list/scroll_snap_list.dart';

// ignore: must_be_immutable
class CalendarScreen extends StatefulWidget {
  String loggedInUsername;

  CalendarScreen({
    super.key,
    required this.loggedInUsername,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<dynamic>> _events = {};
  int _focusedIndex = 0;

  Future<void> _fetchTruckDates() async {
    final userRecordsUrl = Uri.https(
      'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users/${widget.loggedInUsername}/trucks.json',
    );

    try {
      final response = await http.get(userRecordsUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(response.body);

        Map<DateTime, List<dynamic>> events = {};

        data.forEach((key, value) {
          if (value['scheduledDate'] != null) {
            DateTime date = DateTime.parse(value['scheduledDate']);
            events[date] = events[date] ?? [];
            events[date]!.add(value);
          }
        });

        // sort the keys in ascending order
        var sortedKeys = events.keys.toList()..sort();
        Map<DateTime, List<dynamic>> sortedEvents = {
          for (var k in sortedKeys) k: events[k]!
        };

        setState(() {
          _events = sortedEvents;
        });
      } else {
        throw Exception('Failed to load truck dates');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTruckDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        key: const Key("background_key"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Calendar',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 270,
                child: _events.isEmpty
                    ? const Center(
                        child: Text(
                          'Nothing to show.',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    // reference: Flutter Horizontal List with A Snap Effect | Flutter Tutorials | Flutter Tutorials, https://www.youtube.com/watch?v=qx4JphWeVao&t=252s
                    : ScrollSnapList(
                        itemSize: MediaQuery.of(context).size.width * 0.5,
                        onItemFocus: (index) {
                          setState(() {
                            _focusedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final date = _events.keys.elementAt(index);
                          final trucks = _events[date]!;

                          String formattedDate = DateFormat('d').format(date);
                          String formattedDay = DateFormat('E').format(date);
                          String formattedMonthYear =
                              DateFormat('MMMM yyyy').format(date);

                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: _focusedIndex == index
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 153, 218, 148),
                                      width: 3.0)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  formattedDay,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 60.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formattedMonthYear,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                for (var truck in trucks)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Scheduled at: ${truck['scheduledTime']}'),
                                      Text(
                                          'License Plate: ${truck['licensePlate']}'),
                                      Text('Origin: ${truck['origin']}'),
                                      Text(
                                          'Destination: ${truck['destination']}'),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                        itemCount: _events.length,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
