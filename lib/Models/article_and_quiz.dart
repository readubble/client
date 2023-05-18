class ArticleAndQuiz {
  final ProblemInfo problem;
  final List<QuizInfo> quizList;

  ArticleAndQuiz({
    required this.problem,
    required this.quizList,
  });

  factory ArticleAndQuiz.fromJson(Map<String, dynamic> json) {
    final problemInfo = ProblemInfo.fromJson(json['problem']);
    final quizList = List<QuizInfo>.from(
        json['quiz'].map((quiz) => QuizInfo.fromJson(quiz)));
    return ArticleAndQuiz(
      problem: problemInfo,
      quizList: quizList,
    );
  }
}

class ProblemInfo {
  final String title;
  final List<List<String>> content; // 본문 내용은 2차원 배열
  final String level;
  final String author;

  ProblemInfo({
    required this.title,
    required this.content,
    required this.level,
    required this.author,
  });

  factory ProblemInfo.fromJson(Map<String, dynamic> json) {
    return ProblemInfo(
      title: json['title'],
      content: List<List<String>>.from(
          json['content'].map((row) => List<String>.from(row))),
      level: json['level'],
      author: json['author'],
    );
  }
}

class QuizInfo {
  final String problem;
  final List<String> choices;
  final int answer;

  QuizInfo({
    required this.problem,
    required this.choices,
    required this.answer,
  });

  factory QuizInfo.fromJson(Map<String, dynamic> json) {
    final choicesList =
        List<String>.from(json['choices'].map((choice) => choice.toString()));
    return QuizInfo(
      problem: json['problem'],
      choices: choicesList,
      answer: json['answer'],
    );
  }
}
