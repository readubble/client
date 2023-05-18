class ReadingResultModel {
  final String time;
  final List<dynamic> keywords;
  final List<dynamic> sentence;
  final String summarization;
  final String aiSummarization;
  final String saveFl;

  ReadingResultModel(
      {required this.time,
      required this.keywords,
      required this.sentence,
      required this.summarization,
      required this.aiSummarization,
      required this.saveFl});

  factory ReadingResultModel.fromJson(Map<String, dynamic> json) {
    // final sentenceList = List<String>.from(
    //     json['sentence'].map((sentence) => sentence.toString()));

    return ReadingResultModel(
      time: json['time'],
      keywords: json['keyword'],
      sentence: json['sentence'],
      summarization: json['summarization'],
      aiSummarization: json['ai-summarization'],
      saveFl: json['save_fl'],
    );
  }
}
