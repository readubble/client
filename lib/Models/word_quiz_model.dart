class WordQuizModel {
  String quiz, solved;
  List<dynamic> choices;
  int quizId, answer, solvedChoice;

  WordQuizModel({
    required this.quizId,
    required this.quiz,
    required this.choices,
    required this.answer,
    required this.solved,
    required this.solvedChoice,
  });

  factory WordQuizModel.fromJson(Map<String, dynamic> json) {
    return WordQuizModel(
      quizId: json['quizId'],
      quiz: json['quiz'],
      choices: List<dynamic>.from(json['choices']),
      answer: json['answer'],
      solved: json['solved'],
      solvedChoice: json['solvedChoice'],
    );
  }
}
