class ReadingResultModel {
  final String time;
  final List<dynamic> keywords;
  final List<dynamic> sentence;
  final String summarization;
  final String aiSummarization;
  final String saveFl;
  final int problemId;

  ReadingResultModel(
      {required this.time,
      required this.keywords,
      required this.sentence,
      required this.summarization,
      required this.aiSummarization,
      required this.saveFl,
      required this.problemId});

  factory ReadingResultModel.fromJson(Map<String, dynamic> json) {
    return ReadingResultModel(
      time: json['time'],
      keywords: json['keyword'],
      sentence: json['sentence'],
      summarization: json['summarization'],
      aiSummarization: json['ai-summarization'],
      saveFl: json['save_fl'],
      problemId: json['problem_id'],
    );
  }
}
