import 'package:bwageul/Models/article_and_quiz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizListProvider with ChangeNotifier {
  List<QuizInfo> _quizList = [];

  List<QuizInfo> get quizList => _quizList;

  void setQuizList(List<QuizInfo> quizList) {
    _quizList = quizList;
    notifyListeners();
  }
}
