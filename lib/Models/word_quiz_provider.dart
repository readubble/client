import 'package:bwageul/Models/word_quiz_model.dart';
import 'package:flutter/material.dart';

class WordQuizProvider extends ChangeNotifier {
  WordQuizModel? _wordQuizModel;

  WordQuizModel? get wordQuizModel => _wordQuizModel;

  void setWordQuizModel(WordQuizModel model) {
    _wordQuizModel = model;
    notifyListeners();
  }

  void setSolved(String flag) {
    if (_wordQuizModel != null) {
      _wordQuizModel!.solved = flag;
      notifyListeners();
    }
  }

  void setSolvedChoice(int k) {
    if (_wordQuizModel != null) {
      _wordQuizModel!.solvedChoice = k;
      notifyListeners();
    }
  }
}
