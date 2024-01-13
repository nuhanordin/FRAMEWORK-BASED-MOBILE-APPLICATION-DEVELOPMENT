// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
/*
Author: Nuha Nordin
Project: Haulify
File: truck_scheduling.dart
*/
import 'package:flutter/material.dart';
import '../../utils/background.dart';
import 'package:intl/intl.dart';
import '../../models/truck_model.dart';

class ScheduleTruckScreen extends StatefulWidget {
  final Truck selectedTruck;
  final Function(Truck) onUpdateSchedule;
  final List<Truck> scheduledTrucks;

  const ScheduleTruckScreen({
    super.key,
    required this.selectedTruck,
    required this.onUpdateSchedule,
    required this.scheduledTrucks,
  });

  @override
  _ScheduleTruckScreenState createState() => _ScheduleTruckScreenState();
}

class _ScheduleTruckScreenState extends State<ScheduleTruckScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dateController.text = formattedDate;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      timeController.text = pickedTime.format(context);
    }
  }

  void _scheduleTruck() async {
    if (_formKey.currentState!.validate()) {
      widget.selectedTruck.scheduledDate = dateController.text;
      widget.selectedTruck.scheduledTime = timeController.text;
      widget.selectedTruck.origin = originController.text;
      widget.selectedTruck.destination = destinationController.text;

      print('Scheduled Truck: ${widget.selectedTruck}');

      widget.onUpdateSchedule(widget.selectedTruck);
      Navigator.pop(context);
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Schedule for '${widget.selectedTruck.licensePlate}'",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                  labelText: 'Date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: timeController,
                                decoration: const InputDecoration(
                                  labelText: 'Time',
                                  prefixIcon: Icon(Icons.access_time),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: originController,
                            decoration: const InputDecoration(
                              labelText: 'Origin',
                              prefixIcon: Icon(Icons.departure_board),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the origin';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: destinationController,
                            decoration: const InputDecoration(
                              labelText: 'Destination',
                              prefixIcon: Icon(Icons.share_arrival_time),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter the destination';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
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
                                onPressed: _scheduleTruck,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromARGB(255, 131, 170, 119),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  minimumSize: const Size(190, 50),
                                ),
                                child: const Text('Schedule'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )))));
  }
}
