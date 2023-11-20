import 'package:flutter/material.dart';

import './answer.dart';
import './question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> questions;
  //final VoidCallback answerQuestion;

  //Purpose: to rectify an error when calling VoidCallback when using
  final Function answerQuestion;
  final int questionIndex;

  const Quiz(
      {Key? key,
      required this.questions,
      required this.answerQuestion,
      required this.questionIndex})
      : super(key: key);

  /*@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(
          questions[questionIndex]['questionText'] as String,
        ),
        ...(questions[questionIndex]['answer'] as List<Map<String, Object>>)
            .map((answer) {
          return Answer(
            () => answerQuestion(answer['score']),
            answer['text'].toString(),
          );
        }).toList(),
      ],
    );
  }
}*/

  @override
  Widget build(BuildContext context) {
    if (questionIndex < 0 || questionIndex >= questions.length) {
      return Text("No more questions");
    }

    final question = questions[questionIndex];
    final questionText = question['questionText'] as String;
    final answers = question['answer'] as List<Map<String, Object>>;

    return Column(
      children: [
        Question(questionText),
        ...answers.map((answer) {
          return Answer(
            () => answerQuestion(answer['score'] as int),
            answer['text'] as String,
          );
        }).toList(),
      ],
    );
  }
}
