/*
Author: Nuha Nordin
Date: 8/12/23
Purpose: e-Voting UI for ABC Sdn. Bhd.
*/
import 'package:flutter/material.dart';
import 'screen1.dart';
import 'screen2.dart';
import 'screen3.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Screen1(),
        '/employee_details': (context) => Screen2(),
        '/vote_screen': (context) => Screen3(),
      },
    );
  }
}
