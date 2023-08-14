class ArticleAndQuiz {
  final Article problem;
  final List<Exercise> quizList;

  ArticleAndQuiz({
    required this.problem,
    required this.quizList,
  });

  factory ArticleAndQuiz.fromJson(Map<String, dynamic> json) {
    final problemInfo = Article.fromJson(json['article']);
    final quizList = List<Exercise>.from(
        json['exercises'].map((quiz) => Exercise.fromJson(quiz)));
    return ArticleAndQuiz(
      problem: problemInfo,
      quizList: quizList,
    );
  }
}

class Article {
  final String title;
  final List<List<String>> content; // 본문 내용은 2차원 배열
  final String level;
  final String author;

  Article({
    required this.title,
    required this.content,
    required this.level,
    required this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      content: List<List<String>>.from(
          json['content'].map((row) => List<String>.from(row))),
      level: json['level'],
      author: json['author'],
    );
  }
}

class Exercise {
  final String problem;
  final List<String> choices;
  final int answer;

  Exercise({
    required this.problem,
    required this.choices,
    required this.answer,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final choicesList =
        List<String>.from(json['choices'].map((choice) => choice.toString()));
    return Exercise(
      problem: json['problem'],
      choices: choicesList,
      answer: json['answer'],
    );
  }
}
