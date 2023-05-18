class WordBookmarkModel {
  String wordNm, wordMean;
  int targetCode;

  WordBookmarkModel({
    required this.wordNm,
    required this.wordMean,
    required this.targetCode,
  });

  factory WordBookmarkModel.fromJson(Map<String, dynamic> json) {
    return WordBookmarkModel(
      wordNm: json['wordNm'],
      targetCode: json['targetCode'],
      wordMean: json['wordMean'],
    );
  }
}
