import 'package:flutter/material.dart';

import '../Models/article_and_quiz.dart';

class ProblemInfoProvider with ChangeNotifier {
  Article? _problemInfo;

  Article? get problemInfo => _problemInfo;

  void setProblemInfo(Article problemInfo) {
    _problemInfo = problemInfo;
    notifyListeners();
  }
}
