// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
/*
Author: Nuha Nordin
Project: Haulify
File: home.dart
*/
import 'package:flutter/material.dart';
import '../utils/background.dart';
import '../models/truck_model.dart';
import 'profile.dart';
import 'trucks/truck_edit.dart';
import 'trucks/truck_utilization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'trucks/truck_registration.dart';
import 'trucks/truck_scheduling.dart';
import 'trucks/truck_movement.dart';

class HomeScreen extends StatefulWidget {
  final String loggedInUsername;
  const HomeScreen({super.key, required this.loggedInUsername});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TruckRegistrationScreen(
                      onTruckRegistered: _handleTruckRegistered,
                      loggedInUsername: widget.loggedInUsername,
                    )));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TruckUtilizationScreen(
                      loggedInUsername: widget.loggedInUsername,
                    )));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(loggedInUsername: widget.loggedInUsername),
            ));
        break;
    }
  }

  List<Truck> registeredTrucks = [];
  List<Truck> scheduledTrucks = [];
  List<Truck> movingTrucks = [];

  @override
  void initState() {
    super.initState();
    _loadTrucks();
  }

  void _loadTrucks() async {
    try {
      final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.loggedInUsername}/trucks.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> truckData = json.decode(response.body);

        final List<Truck> trucks = truckData.entries.map<Truck>((entry) {
          final key = entry.key;
          final truck = entry.value as Map<String, dynamic>;

          return Truck(
            key: key,
            id: truck['id'],
            licensePlate: truck['licensePlate'],
            model: truck['model'],
            capacity: truck['capacity'],
            use: truck['use'],
            scheduledDate: truck['scheduledDate'],
            scheduledTime: truck['scheduledTime'],
            origin: truck['origin'],
            destination: truck['destination'],
            movement: truck['movement'],
          );
        }).toList();

        setState(() {
          // only add trucks without date/time
          registeredTrucks = trucks
              .where((truck) =>
                  truck.scheduledDate == null && truck.scheduledTime == null)
              .toList();

          // add scheduled trucks to scheduledTrucks list
          scheduledTrucks = trucks
              .where((truck) =>
                  (truck.scheduledDate != null ||
                      truck.scheduledTime != null) &&
                  truck.movement == null) // exclude trucks with movement
              .toList();

          // add moving trucks to movingTrucks list
          movingTrucks =
              trucks.where((truck) => truck.movement != null).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to load trucks. Status Code: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Error loading trucks'),
      //   ),
      // );
    }
  }

  //reference: Flutter Firebase Realtime Database CRUD | Flutter Firebase CRUD, https://www.youtube.com/watch?v=LbgsJl-dQsU
  void _updateTruckSchedule(Truck updatedTruck) async {
    try {
      if (updatedTruck.key == null) {
        // If the key is null, retrieve the key from Firebase
        final url = Uri.https(
          'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
          'users/${widget.loggedInUsername}/trucks.json',
        );

        final response = await http.get(url);
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Find the key of the truck in Firebase based on its other attributes
        final matchingTruck = data.entries.firstWhere(
          (entry) {
            final truckData = entry.value as Map<String, dynamic>;
            return truckData['id'] == updatedTruck.id;
          },
          // orElse: () => null,
        );

        if (matchingTruck != null) {
          updatedTruck.key = matchingTruck.key;
        } else {
          print('Truck not found in Firebase');
          return;
        }
      }

      final updateUrl = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.loggedInUsername}/trucks/${updatedTruck.key}.json',
      );

      await http.patch(
        updateUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': updatedTruck.id,
          'licensePlate': updatedTruck.licensePlate,
          'model': updatedTruck.model,
          'capacity': updatedTruck.capacity,
          'use': updatedTruck.use,
          'scheduledDate': updatedTruck.scheduledDate,
          'scheduledTime': updatedTruck.scheduledTime,
          'origin': updatedTruck.origin,
          'destination': updatedTruck.destination,
          'movement': updatedTruck.movement,
        }),
      );

      setState(() {
        // update the local list of registeredTrucks
        final index =
            registeredTrucks.indexWhere((t) => t.key == updatedTruck.key);
        if (index != -1) {
          registeredTrucks[index] = updatedTruck;

          // remove the truck from registeredTrucks
          registeredTrucks.removeAt(index);
        }

        // check if the truck is still scheduled and update scheduledTrucks
        if (updatedTruck.scheduledDate != null ||
            updatedTruck.scheduledTime != null) {
          if (!scheduledTrucks.contains(updatedTruck)) {
            scheduledTrucks.add(updatedTruck);
          }
        } else {
          // if it's not scheduled anymore, remove it from scheduledTrucks
          scheduledTrucks.remove(updatedTruck);
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error updating truck schedule'),
      ));
    }
  }

  void _updateTruckMovement(
      Truck updatedTruck, double movementPercentage) async {
    try {
      final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.loggedInUsername}/trucks/${updatedTruck.key}.json',
      );

      if (movementPercentage >= 100) {
        // if movement = 100%, set date, time, origin, destination, and set movement to null
        await http.put(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': updatedTruck.id,
              'licensePlate': updatedTruck.licensePlate,
              'model': updatedTruck.model,
              'capacity': updatedTruck.capacity,
              'use': updatedTruck.use,
              'scheduledDate': null,
              'scheduledTime': null,
              'origin': null,
              'destination': null,
              'movement': null,
            }));

        setState(() {
          movingTrucks.remove(updatedTruck);

          // if movement is 100%, add the updatedTruck to registeredTrucks
          registeredTrucks.add(updatedTruck.copyWith(
            scheduledDate: null,
            scheduledTime: null,
            origin: null,
            destination: null,
            movement: null,
          ));
        });
      } else {
        // if movement < 100%, update movement only
        await http.put(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': updatedTruck.id,
              'licensePlate': updatedTruck.licensePlate,
              'model': updatedTruck.model,
              'capacity': updatedTruck.capacity,
              'use': updatedTruck.use,
              'scheduledDate': updatedTruck.scheduledDate,
              'scheduledTime': updatedTruck.scheduledTime,
              'origin': updatedTruck.origin,
              'destination': updatedTruck.destination,
              'movement': movementPercentage.toString(),
            }));

        setState(() {
          scheduledTrucks.remove(updatedTruck);
          movingTrucks.remove(updatedTruck);
          movingTrucks.add(updatedTruck.copyWith(
            movement: movementPercentage.toString(),
          ));
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error updating truck movement'),
      ));
    }
  }

  void _removeTruck(Truck truck) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this truck?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final index = registeredTrucks.indexOf(truck);
      setState(() {
        registeredTrucks.remove(truck);
      });

      try {
        final url = Uri.https(
          'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
          'users/${widget.loggedInUsername}/trucks/${truck.key}.json',
        );

        final response = await http.delete(url);

        if (response.statusCode >= 400) {
          setState(() {
            registeredTrucks.insert(index, truck);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Truck deleted'),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error deleting truck'),
          ),
        );
      }
    }
  }

  void _handleTruckRegistered(Truck newTruck) {
    setState(() {
      if (newTruck.scheduledDate != null || newTruck.scheduledTime != null) {
        scheduledTrucks.add(newTruck);
      } else {
        registeredTrucks.add(newTruck);
      }
    });
  }

  void _editTruck(Truck editedTruck) async {
    try {
      final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.loggedInUsername}/trucks/${editedTruck.key}.json',
      );

      final response = await http.patch(
        url,
        body: json.encode({
          'licensePlate': editedTruck.licensePlate,
          'model': editedTruck.model,
          'capacity': editedTruck.capacity,
          'use': editedTruck.use,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          int index = registeredTrucks
              .indexWhere((truck) => truck.key == editedTruck.key);
          registeredTrucks[index] = editedTruck;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Truck details updated')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed update truck details')),
        );
      }
    } catch (error) {
      print('Error editing truck details: $error');
    }
  }

  void _cancelTruckSchedule(Truck updatedTruck) async {
    try {
      final url = Uri.https(
        'haulify-2406e-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.loggedInUsername}/trucks/${updatedTruck.key}.json',
      );

      Map<String, dynamic> updateData = {
        'movement': updatedTruck.movement,
      };

      if (updatedTruck.scheduledDate != null ||
          updatedTruck.scheduledTime != null) {
        updateData['scheduledDate'] = null;
        updateData['scheduledTime'] = null;
        updateData['origin'] = null;
        updateData['destination'] = null;
      }

      await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      _loadTrucks();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error updating truck schedule'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
          key: const Key("background_key"),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Container(
                          margin: const EdgeInsets.only(top: 90),
                          child: const Text('Trucks',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ))))),
              registeredTrucks.isEmpty
                  ? const Center(child: Text('No truck yet.'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: registeredTrucks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: const BorderSide(color: Colors.black),
                            ),
                            elevation: 1.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 226, 218, 187)
                                            .withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 63, 126, 65),
                                      child: Text(
                                        registeredTrucks[index].id.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(
                                      'License Plate: ${registeredTrucks[index].licensePlate}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.card_membership,
                                      color: Colors.black,
                                    ),
                                    title: Text(
                                      'Model: ${registeredTrucks[index].model}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.scale,
                                        color: Colors.black),
                                    title: Text(
                                      'Capacity: ${registeredTrucks[index].capacity} kg',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.shopping_basket,
                                      color: Colors.black,
                                    ),
                                    title: Text(
                                      'Use: ${registeredTrucks[index].use}',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          var editedTruck =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditTruckScreen(
                                                initialTruck:
                                                    registeredTrucks[index],
                                              ),
                                            ),
                                          );

                                          if (editedTruck != null &&
                                              editedTruck is Truck) {
                                            _editTruck(editedTruck);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: const Color.fromARGB(
                                              255, 220, 236, 215),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          minimumSize: const Size(20, 40),
                                        ),
                                        child: const Text('Edit'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduleTruckScreen(
                                                selectedTruck:
                                                    registeredTrucks[index],
                                                onUpdateSchedule:
                                                    _updateTruckSchedule,
                                                scheduledTrucks:
                                                    scheduledTrucks,
                                              ),
                                            ),
                                          );

                                          if (result != null &&
                                              result is Truck) {
                                            setState(() {
                                              _updateTruckSchedule(result);
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: const Color.fromARGB(
                                              255, 131, 170, 119),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          minimumSize: const Size(20, 40),
                                        ),
                                        child: const Text('Schedule'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _removeTruck(registeredTrucks[index]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: const Color.fromARGB(
                                              255, 230, 84, 84),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          minimumSize: const Size(20, 40),
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 70),
              scheduledTrucks.isEmpty
                  ? const Center(child: Text('No scheduled truck.'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 8.0),
                          child: Text(
                            'Scheduled Trucks',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: scheduledTrucks.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                elevation: 1.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 226, 218, 187)
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 119, 180, 121),
                                          child: Text(
                                            scheduledTrucks[index]
                                                .id
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          'License Plate: ${scheduledTrucks[index].licensePlate}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                              Icons.date_range,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              'Date: ${scheduledTrucks[index].scheduledDate ?? 'Not scheduled'}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.access_time,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              'Time: ${scheduledTrucks[index].scheduledTime ?? 'Not scheduled'}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.departure_board,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              'Origin: ${scheduledTrucks[index].origin ?? 'Not scheduled'}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                              Icons.share_arrival_time,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              'Destination: ${scheduledTrucks[index].destination ?? 'Not scheduled'}',
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ButtonBar(
                                        alignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              var result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScheduleTruckScreen(
                                                    selectedTruck:
                                                        scheduledTrucks[index],
                                                    onUpdateSchedule:
                                                        _updateTruckSchedule,
                                                    scheduledTrucks:
                                                        scheduledTrucks,
                                                  ),
                                                ),
                                              );

                                              if (result != null &&
                                                  result is Truck) {
                                                setState(() {
                                                  _updateTruckSchedule(result);
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 168, 213, 156),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              minimumSize: const Size(20, 40),
                                            ),
                                            child: const Text('Edit'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              var result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TruckMovementScreen(
                                                    selectedTruck:
                                                        scheduledTrucks[index],
                                                    initialMovement: 0.0,
                                                  ),
                                                ),
                                              );

                                              if (result != null &&
                                                  result is Truck) {
                                                _updateTruckMovement(
                                                    result,
                                                    double.parse(
                                                        result.movement!));
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 131, 170, 119),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              minimumSize: const Size(20, 40),
                                            ),
                                            child: const Text('Ready to Move'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              Truck canceledTruck =
                                                  scheduledTrucks[index];
                                              setState(() {
                                                scheduledTrucks.removeAt(index);
                                                registeredTrucks
                                                    .add(canceledTruck);
                                              });

                                              _cancelTruckSchedule(
                                                canceledTruck.copyWith(
                                                  scheduledDate: null,
                                                  scheduledTime: null,
                                                  origin: null,
                                                  destination: null,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 230, 84, 84),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              minimumSize: const Size(20, 40),
                                            ),
                                            child:
                                                const Text('Cancel Schedule'),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
              movingTrucks.isEmpty
                  ? const Center(child: Text('No moving truck.'))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                            top: 8.0,
                          ),
                          child: Text(
                            'Moving Trucks',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movingTrucks.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                                elevation: 1.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 226, 218, 187)
                                            .withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 161, 209, 162),
                                          child: Text(
                                            movingTrucks[index].id.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'License Plate: ${movingTrucks[index].licensePlate}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Movement: ${movingTrucks[index].movement ?? 'Not moving'}%',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 13,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            var result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TruckMovementScreen(
                                                  selectedTruck:
                                                      movingTrucks[index],
                                                  initialMovement: double.parse(
                                                      movingTrucks[index]
                                                              .movement ??
                                                          '0.0'),
                                                ),
                                              ),
                                            );

                                            if (result != null &&
                                                result is Truck) {
                                              _updateTruckMovement(
                                                  result,
                                                  double.parse(
                                                      result.movement!));
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 168, 213, 156),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            minimumSize: const Size(20, 40),
                                          ),
                                          child: const Text('Update Movement'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 300),
                      ],
                    ),
            ]),
          ),
        ),
        // reference:
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            elevation: 10.0,
            selectedItemColor: const Color.fromARGB(255, 88, 166, 120),
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
              )
            ]));
  }
}
