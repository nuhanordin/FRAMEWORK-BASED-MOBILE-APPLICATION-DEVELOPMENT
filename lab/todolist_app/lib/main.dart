/* Author: Nuha Nordin
Date: 19 Nov 2023
Purpose: To create a simple To-Do List app by applying ShowDialogBox widget and ListView.builder
*/

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MyMainPage(),
      theme: ThemeData(
        primaryColor: Colors.pink, // Set the primary color to pink
        fontFamily: 'Arial', // Change the font family
      ),
    ));

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  // initialise a to-do list records
  List<String> _todoRecords = ['Task 1', 'Task 2', 'Task 3', 'Task 4'];

  void _addingToDo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newToDo = '';

        return AlertDialog(
          title: Text(
            'Enter New Task Below:',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.pink), // Example style change
          ),
          content: TextField(
            onChanged: (value) {
              newToDo = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red), // Example style change
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _todoRecords.add(newToDo);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.pink), // Example style change
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 4.0, // Example elevation change
      ),
      body: ListView.builder(
        itemCount: _todoRecords.length,
        itemBuilder: (context, index) {
          final toDo = _todoRecords[index];

          return Dismissible(
            key: Key(toDo),
            onDismissed: (direction) {
              setState(() {
                _todoRecords.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task dismissed: $toDo'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _todoRecords.insert(index, toDo);
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.pinkAccent, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  toDo,
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
                subtitle: Text('Additional details here'), // Example subtitle
                onTap: () {
                  setState(() {
                    _todoRecords.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addingToDo,
        backgroundColor: Colors.pink,
        tooltip: 'Add a new task', // Example tooltip
      ),
    );
  }
}
