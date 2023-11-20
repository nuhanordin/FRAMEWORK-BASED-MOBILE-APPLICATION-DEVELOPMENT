import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  //const ({Key? key}) : super(key: key);
  //final VoidCallbackAction selectHandler;
  final Function selectHandler;
  final String answerText;

  //define constructor
  Answer(this.selectHandler, this.answerText) {
    print('Rebuild Answer Widget..');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //only have child (1 widget). column can have more than 1
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: Text(answerText),
        onPressed: () => selectHandler(),
      ),
    );
  }
}
