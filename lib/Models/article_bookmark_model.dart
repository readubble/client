class ArticleBookmarkModel {
  final int id;
  final String atcTitle;
  final String atcWriter;
  final String atcPhotoIn;
  final String difficulty;
  final DateTime regDt;
  final int cgID;
  final String genre;

  ArticleBookmarkModel(
      {required this.id,
      required this.atcTitle,
      required this.atcWriter,
      required this.atcPhotoIn,
      required this.difficulty,
      required this.regDt,
      required this.cgID,
      required this.genre});

  factory ArticleBookmarkModel.fromJson(Map<String, dynamic> json) {
    return ArticleBookmarkModel(
        id: json['id'],
        atcTitle: json['atcTitle'],
        atcWriter: json['atcWriter'],
        atcPhotoIn: json['atcPhotoIn'],
        difficulty: json['difficulty'],
        regDt: json['regDt'],
        cgID: json['cgID'],
        genre: json['genre']);
  }
}
