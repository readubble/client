import 'package:flutter/material.dart';

import '../Models/article_and_quiz.dart';

class ProblemInfoProvider with ChangeNotifier {
  ProblemInfo? _problemInfo;

  ProblemInfo? get problemInfo => _problemInfo;

  void setProblemInfo(ProblemInfo problemInfo) {
    _problemInfo = problemInfo;
    notifyListeners();
  }
}
