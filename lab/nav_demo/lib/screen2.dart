/*
Author: Nuha Nordin
Date: 8/12/23
Purpose: e-Voting UI for ABC Sdn. Bhd.
*/
import 'package:flutter/material.dart';

class EmployeeDetails {
  final String candidateNumber;
  final String staffNumber;
  final String department;

  EmployeeDetails(this.candidateNumber, this.staffNumber, this.department);
}

class Screen2 extends StatelessWidget {
  final List<EmployeeDetails> employeeList = [
    EmployeeDetails('A', '001', 'Information Technology'),
    EmployeeDetails('B', '002', 'Human Resource'),
    EmployeeDetails('C', '003', 'Marketing'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Employee Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Employee Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Candidate')),
                  DataColumn(label: Text('Staff Number')),
                  DataColumn(label: Text('Department')),
                ],
                rows: employeeList.map((employee) {
                  return DataRow(
                    cells: [
                      DataCell(Text(employee.candidateNumber)),
                      DataCell(Text(employee.staffNumber)),
                      DataCell(Text(employee.department)),
                    ],
                  );
                }).toList(),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('Back to Home'),
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
          ],
        ),
      ),
    );
  }
}
