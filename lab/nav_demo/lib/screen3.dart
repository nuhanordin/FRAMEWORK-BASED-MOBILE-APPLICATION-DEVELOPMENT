/*
Author: Nuha Nordin
Date: 8/12/23
Purpose: e-Voting UI for ABC Sdn. Bhd.
*/
import 'package:flutter/material.dart';

class Screen3 extends StatefulWidget {
  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String? selectedCandidate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Vote for Candidate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Vote for Candidate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            RadioListTile(
              title: Text('Candidate A'),
              value: 'Candidate A',
              groupValue: selectedCandidate,
              onChanged: (value) {
                setState(() {
                  selectedCandidate = value ?? '';
                });
              },
            ),
            RadioListTile(
              title: Text('Candidate B'),
              value: 'Candidate B',
              groupValue: selectedCandidate,
              onChanged: (value) {
                setState(() {
                  selectedCandidate = value ?? '';
                });
              },
            ),
            RadioListTile(
              title: Text('Candidate C'),
              value: 'Candidate C',
              groupValue: selectedCandidate,
              onChanged: (value) {
                setState(() {
                  selectedCandidate = value ?? '';
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Employee Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (selectedCandidate != null &&
                    selectedCandidate!.isNotEmpty) {
                  print('Vote for $selectedCandidate submitted');
                  Navigator.pushNamed(context, '/');
                } else {
                  print('Please select a candidate before submitting.');
                }
              },
              child: Text('Submit Vote'),
            ),
          ],
        ),
      ),
    );
  }
}
