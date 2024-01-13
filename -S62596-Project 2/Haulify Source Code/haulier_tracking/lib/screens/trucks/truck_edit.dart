/*
Author: Nuha Nordin
Project: Haulify
File: truck_edit.dart
*/
import 'package:flutter/material.dart';
import '../../models/truck_model.dart';
import '../../utils/background.dart';

class EditTruckScreen extends StatefulWidget {
  final Truck initialTruck;

  const EditTruckScreen({super.key, required this.initialTruck});

  @override
  // ignore: library_private_types_in_public_api
  _EditTruckScreenState createState() => _EditTruckScreenState();
}

class _EditTruckScreenState extends State<EditTruckScreen> {
  late TextEditingController licensePlateController;
  late TextEditingController modelController;
  late TextEditingController capacityController;
  late String _selectedUse;

  @override
  void initState() {
    super.initState();

    // initialize controllers with the initial truck details
    licensePlateController =
        TextEditingController(text: widget.initialTruck.licensePlate);
    modelController = TextEditingController(text: widget.initialTruck.model);
    capacityController =
        TextEditingController(text: widget.initialTruck.capacity.toString());
    _selectedUse = widget.initialTruck.use;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
            key: const Key("background_key"),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Edit Truck Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      controller: licensePlateController,
                      decoration:
                          const InputDecoration(labelText: 'License Plate'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(labelText: 'Model'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: capacityController,
                      decoration:
                          const InputDecoration(labelText: 'Capacity (kg)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.shopping_basket),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
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
                          _selectedUse = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
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
                            Truck editedTruck = Truck(
                              key: widget.initialTruck.key,
                              id: widget.initialTruck.id,
                              licensePlate: licensePlateController.text,
                              model: modelController.text,
                              capacity: int.parse(capacityController.text),
                              use: _selectedUse,
                            );

                            Navigator.pop(context, editedTruck);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                const Color.fromARGB(255, 131, 170, 119),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            minimumSize: const Size(190, 50),
                          ),
                          child: const Text('Confirm Edit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
