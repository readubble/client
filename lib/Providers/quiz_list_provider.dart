import 'package:bwageul/Models/article_and_quiz.dart';
import 'package:flutter/material.dart';

class QuizListProvider with ChangeNotifier {
  List<Exercise> _quizList = [];

  List<Exercise> get quizList => _quizList;

  void setQuizList(List<Exercise> quizList) {
    _quizList = quizList;
    notifyListeners();
  }
}
