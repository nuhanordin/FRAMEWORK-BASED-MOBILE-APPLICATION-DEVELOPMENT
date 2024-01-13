/*
Author: Nuha Nordin
Project: Haulify
File: truck_model.dart
*/
class Truck {
  String? key;
  String? id;
  String licensePlate;
  String model;
  int capacity;
  String use;
  String? scheduledDate;
  String? scheduledTime;
  String? origin;
  String? destination;
  String? movement;

  Truck({
    this.key,
    required this.id,
    required this.licensePlate,
    required this.model,
    required this.capacity,
    required this.use,
    this.scheduledDate,
    this.scheduledTime,
    this.origin,
    this.destination,
    this.movement,
  });

  factory Truck.fromJson(Map<String, dynamic> json) {
    return Truck(
      key: json['key'],
      id: json['id'],
      licensePlate: json['licensePlate'],
      model: json['model'],
      capacity: json['capacity'],
      use: json['use'],
      scheduledDate: json['scheduledDate'],
      scheduledTime: json['scheduledTime'],
      origin: json['origin'],
      destination: json['destination'],
      movement: json['movement'],
    );
  }

  @override
  String toString() {
    return 'Truck{'
        'key: $key, '
        'id: $id,'
        'licensePlate: $licensePlate, '
        'model: $model, '
        'capacity: $capacity, '
        'use: $use, '
        'scheduledDate: $scheduledDate, '
        'scheduledTime: $scheduledTime, '
        'origin: $origin, '
        'destination: $destination,'
        'movement: $movement'
        '}';
  }

  Truck copyWith({
    String? key,
    String? id,
    String? licensePlate,
    String? model,
    int? capacity,
    String? use,
    String? scheduledDate,
    String? scheduledTime,
    String? origin,
    String? destination,
    String? movement,
  }) {
    return Truck(
      key: key ?? this.key,
      id: id ?? this.id,
      licensePlate: licensePlate ?? this.licensePlate,
      model: model ?? this.model,
      capacity: capacity ?? this.capacity,
      use: use ?? this.use,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      movement: movement ?? this.movement,
    );
  }
}
