import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandler;

  //const Result {(Key? key)} :super (key: key);

  //Result (this.resultScore);

  Result(this.resultScore,
      this.resetHandler); //add 2nd parameter for function handler..

  String get resultPhrase {
    String resultText = 'Score = $resultScore \n You did it!';
    if (resultScore <= 8) {
      resultText = 'Score = $resultScore \n You are innocent!';
    } else if (resultScore <= 12) {
      resultText = 'Score = $resultScore \n Pretty likeable!';
    } else if (resultScore <= 16) {
      resultText = 'Score = $resultScore \n You are strange!';
    } else {
      resultText = 'Score = $resultScore \n You are so bad!';
    }
    return resultText;
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Text(
          resultPhrase,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () => resetHandler(),
          child: Text('Restart Quiz'),
        )
      ]),
    );
  }
}
