import 'package:bwageul/Services/storage.dart';
import 'package:flutter/material.dart';
import 'package:bwageul/Services/api_services.dart';
import '../Models/word_quiz_model.dart';
import '../main.dart';

Future<List<Widget>> buildWordQuiz() async {
  if (await isLoggedIn()) {
    List<WordQuizModel> quizDataList = await ApiService.getWordQuiz();

    List<Widget> quizList = [];
    for (final data in quizDataList) {
      quizList.add(buildEachQuiz(data));
    }
    return quizList;
  } else {
    throw Exception('로그인이 필요합니다.');
  }
}

Widget buildEachQuiz(WordQuizModel model) {
  // 퀴즈 만드는 함수: 퀴즈제목, 보기1, 보기2
  bool leftButtonClicked = false;
  bool rightButtonClicked = false;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          model.quiz,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 1)
              ]),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: myColor.shade800,
              elevation: 5,
              minimumSize: const Size(120, 40),
              maximumSize: const Size(150, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              model.solvedChoice = 1; // 사용자가 선택한 답
              model.solved = "Y";
            },
            child: Text(
              model.choices[0],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ), // 왼쪽 보기
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: myColor.shade800,
              elevation: 5,
              minimumSize: const Size(120, 40),
              maximumSize: const Size(150, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              model.solvedChoice = 2; // 사용자가 선택한 답
              model.solved = "Y";
            },
            child: Text(
              model.choices[1],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ), // 오른쪽 보기
        ],
      ),
    ],
  );
}
