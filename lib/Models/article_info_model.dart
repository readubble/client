class ArticleInfoModel {
  int id;
  String title, writer, photo, difficulty, genre;

  ArticleInfoModel({
    required this.id,
    required this.title,
    required this.writer,
    required this.photo,
    required this.difficulty,
    required this.genre,
  });
  factory ArticleInfoModel.fromJson(Map<String, dynamic> json) {
    return ArticleInfoModel(
        id: json['id'],
        title: json['atcTitle'],
        writer: json['atcWriter'],
        photo: json['atcPhotoIn'],
        difficulty: json['difficulty'],
        genre: json['genre']);
  }
}
