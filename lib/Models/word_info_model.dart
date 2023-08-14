// 단어 사전 데이터를 서버에서 불러와 객체로 저장
class WordInfoModel {
  String wordNm, wordMean, saveFl;
  int targetCode;

  WordInfoModel({
    required this.wordNm,
    required this.wordMean,
    required this.targetCode,
    required this.saveFl,
  });

  factory WordInfoModel.fromJson(Map<String, dynamic> json) {
    return WordInfoModel(
      wordNm: json['wordNm'],
      targetCode: json['targetCode'],
      wordMean: json['wordMean'],
      saveFl: json['saveFl'],
    );
  }
  dynamic operator [](String key) {
    switch (key) {
      case 'wordNm':
        return wordNm;
      case 'wordMean':
        return wordMean;
      case 'targetCode':
        return targetCode;
      case 'saveFl':
        return saveFl;
      default:
        return null;
    }
  }
}
