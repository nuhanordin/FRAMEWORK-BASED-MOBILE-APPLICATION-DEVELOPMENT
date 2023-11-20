import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  //doesnt change after built
  final String questionText;
  Question(this.questionText); //constructor

  @override
  /*Widget build(BuildContext context) {
    //build - required for any widget that extends StatelessWidget
    return Text(questionText);
  }*/

  Widget build(BuildContext context) {
    return Container(
      //Container - cant see, its invisible
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        questionText,
        style: TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}
