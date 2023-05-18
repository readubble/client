import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProblemIdProvider with ChangeNotifier {
  int? _problemId;

  int? get problemId => _problemId;

  void setProblemId(int problemId) {
    _problemId = problemId;
    notifyListeners();
  }
}
