/*
Author: Nuha Nordin
Date: 8/12/23
Purpose: e-Voting UI for ABC Sdn. Bhd.
*/
import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('e-Voting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/employee_details');
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
                Navigator.pushNamed(context, '/vote_screen');
              },
              child: Text('Vote for Candidate'),
            ),
          ],
        ),
      ),
    );
  }
}
