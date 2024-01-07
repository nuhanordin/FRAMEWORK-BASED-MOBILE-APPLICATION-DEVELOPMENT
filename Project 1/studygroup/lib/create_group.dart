import 'package:flutter/material.dart';
import 'group.dart';

class CreateGroupScreen extends StatelessWidget {
  final Function(Group) onGroupCreated;

  //constructor to receive callback function when group is created
  const CreateGroupScreen({Key? key, required this.onGroupCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
        ),
        body: SingleChildScrollView(
          child: CreateGroupForm(onGroupCreated: onGroupCreated),
        ));
  }
}

class CreateGroupForm extends StatefulWidget {
  final Function(Group) onGroupCreated;

  const CreateGroupForm({Key? key, required this.onGroupCreated})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberOfPeopleController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  //store selected date and time
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  //to show date picker and update the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  //to show time picker and update the selected time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                  labelText: 'Group Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group, color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a group name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                  labelText: 'Location',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on, color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _numberOfPeopleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of People',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.people, color: Colors.black),
                labelStyle: TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of people';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.date_range, color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
              onTap: () => _selectDate(context),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                  labelText: 'Time',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time, color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
              onTap: () => _selectTime(context),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                //validate from and create new group
                if (_formKey.currentState?.validate() ?? false) {
                  String groupName = _groupNameController.text;
                  String location = _locationController.text;
                  int numberOfPeople =
                      int.parse(_numberOfPeopleController.text);
                  String date = _dateController.text;
                  String time = _timeController.text;

                  Group newGroup = Group(
                    name: groupName,
                    location: location,
                    numberOfPeople: numberOfPeople,
                    date: date,
                    time: time,
                  );

                  //call the callback function to notify the parent screen
                  widget.onGroupCreated(newGroup);

                  Navigator.pop(context);
                }
              },
              child: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
