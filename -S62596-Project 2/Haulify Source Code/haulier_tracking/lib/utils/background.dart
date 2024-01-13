/*
Author: Nuha Nordin
Project: Haulify
File: background.dart
*/
import 'package:flutter/material.dart';

// reference: Background - Flutter UI - Login & Register Page - Speed Code,  https://www.youtube.com/watch?v=PMcXhYmFFN4
class Background extends StatelessWidget {
  final Widget child;

  const Background({
    required Key key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/bottom.png",
                width: size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/top.png",
                width: size.width,
              ),
            ),
            child
          ],
        ));
  }
}
