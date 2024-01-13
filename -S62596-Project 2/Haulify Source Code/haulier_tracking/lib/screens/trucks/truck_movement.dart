// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
/*
Author: Nuha Nordin
Project: Haulify
File: truck_movement.dart
*/
import 'package:flutter/material.dart';
import '../../utils/background.dart';
import '../../models/truck_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class TruckMovementScreen extends StatefulWidget {
  final Truck selectedTruck;
  final double initialMovement;

  const TruckMovementScreen(
      {super.key, required this.selectedTruck, required this.initialMovement});

  @override
  _TruckMovementScreenState createState() => _TruckMovementScreenState();
}

class _TruckMovementScreenState extends State<TruckMovementScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  double currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    currentPosition =
        double.parse((widget.initialMovement / 100).toStringAsFixed(2));
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMovement() async {
    try {
      final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.selectedTruck.key}.json',
      );

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'movement': currentPosition.toString(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movement updated successfully'),
          ),
        );

        // if update successful, update local
        setState(() {
          widget.selectedTruck.movement = currentPosition.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating movement'),
          ),
        );
      }
    } catch (error) {
      print('Error updating movement: $error');
    }
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
                  // reference: Flutter Easy Animations | Flutter Animated Splash Screen | Flutter Click Animation, https://www.youtube.com/watch?v=_6JVCrxnyOA&list=WL&index=1
                  Lottie.network(
                      "https://lottie.host/26c9bce8-bbb0-48f0-9834-3a96fd8929e7/a1OZeY4DAC.json",
                      controller: _controller, onLoaded: (compos) {
                    _controller
                      ..duration = compos.duration
                      ..repeat();
                  }, width: 350),
                  Text(
                    "Movement for '${widget.selectedTruck.licensePlate}'",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // reference: Simple SLIDER • Flutter Widget of the Day #24, https://www.youtube.com/watch?v=c2Gz8siAqSQ
                    child: Slider(
                      value: currentPosition,
                      onChanged: (value) {
                        setState(() {
                          currentPosition =
                              double.parse(value.toStringAsFixed(2));
                        });
                      },
                      min: 0,
                      max: 1,
                      divisions: 100,
                      label:
                          'Move to ${(widget.selectedTruck.destination != null) ? (currentPosition * 100).toStringAsFixed(0) : 0}% closer',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.place,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 5),
                            Text(
                                ' ${widget.selectedTruck.origin ?? 'Not scheduled'}'),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.flag,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 5),
                            Text(
                                ' ${widget.selectedTruck.destination ?? 'Not scheduled'}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 230, 84, 84),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          minimumSize: const Size(120, 50),
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _updateMovement();
                          widget.selectedTruck.movement =
                              (currentPosition * 100).toString();
                          Navigator.pop(context, widget.selectedTruck);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor:
                              const Color.fromARGB(255, 168, 213, 156),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          minimumSize: const Size(190, 50),
                        ),
                        child: const Text('Update Movement'),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
