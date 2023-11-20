import 'package:flutter/material.dart';
//import './question.dart';
//import './answer.dart';
import './result.dart';
import './quiz.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  //to keep the answer, rather have accumulation
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  //define list
  final _questions = [
    {
      'questionText': 'What \'s your favorite color?',
      //'answer': ['Black', 'Red', 'Green', 'Blue'],
      'answer': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 5},
        {'text': 'Green', 'score': 3},
        {'text': 'Blue', 'score': 1},
      ],
    },
    {
      'questionText': 'What \'s your favorite animal?',
      //'answer': ['Cat', 'Tiger', 'Lion', 'Rabbit'],
      'answer': [
        {'text': 'Cat', 'score': 1},
        {'text': 'Tiger', 'score': 10},
        {'text': 'Lion', 'score': 8},
        {'text': 'Rabbit', 'score': 3},
      ],
    },
    {
      'questionText': 'What \'s your favorite instructor?',
      //'answer': ['Alan', 'David', 'Richard', 'Steven'],
      'answer': [
        {'text': 'Alan', 'score': 8},
        {'text': 'David', 'score': 5},
        {'text': 'Richard', 'score': 1},
        {'text': 'Steven', 'score': 3},
      ],
    },
  ];

  /*void _answerQuestion() {
    //print('Answer chosen..');
    setState(() {
      //locking a data. the current data not eliminated
      _questionIndex = _questionIndex + 1;
    });

    print(_questionIndex);
  }*/

  var _questionIndex = 0;
  var _totalScore = 0;

  //add method to reset the quiz again
  void resetQuiz() {
    //reset to zero again
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });

    print(_questionIndex);

    if (_questionIndex < _questions.length) {
      print('We have more questions..');
    } else {
      print('No more questions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Quiz App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore, resetQuiz),
        /*? Column(
                  children: [
                    Question(
                      _questions[_questionIndex]['questionText'] as String,
                    ),
                    ...(_questions[_questionIndex]['answer'] as List<String>)
                        .map((answer) {
                      return Answer(_answerQuestion, answer);
                    }).toList(),
                  ],
                  //column widget to group widgets together
                  //ElevatedButton(onPressed: _answerQuestion, child: Text('Answer 1')),
                  //ElevatedButton(onPressed: _answerQuestion, child: Text('Answer 2')),
                  //ElevatedButton(onPressed: _answerQuestion, child: Text('Answer 3')),
                
              : const Center(
                  child: Text('You do it...'),*/
      ),
    );
  }
}
