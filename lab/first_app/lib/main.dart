import 'package:flutter/material.dart';

void main() {
  //1. Widget -> to appear in the screen
  //2. use widget -> Center
  //3. then use center to add child widget -> child:Widget
  //(try to center it on the screen)
  //4. specify the properties for Text's widget

  //Passing the value of your name in text Welcome to My Flutter App your name ..! through the variable in your code.
  String name = "Nuha";

  runApp(Center(
      child: Text('Welcome to My Flutter App $name',
          textDirection: TextDirection.ltr,
          style: TextStyle(
              color: Colors.orangeAccent, //change the font-size to 20
              fontSize: 20, //change text color with orangeAccent
              fontStyle: FontStyle.italic)))); //change font-style to italic
}
