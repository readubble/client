import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import '../Models/article_info_model.dart';

Widget buildArticleList(List<ArticleInfoModel> articleList) {
  return SizedBox(
    height: 240,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: articleList.length,
      itemBuilder: (BuildContext context, int index) {
        ArticleInfoModel article = articleList[index];
        return Row(children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/startReading', arguments: {
                'photo': article.photo,
                'genre': article.genre,
                'difficulty': article.difficulty,
                'title': article.title,
                'writer': article.writer,
                'problemId': article.id,
              });
            },
            child: unlockedArticleTile(context, article.photo, article.genre,
                article.difficulty, article.title, 1),
          ),
          const SizedBox(
            width: 15,
          )
        ]);
      },
    ),
  );
}

Widget unlockedArticleTile(BuildContext context, String imageURL,
    String subCategory, String level, String title, int size) {
  // 각 글(타일)을 리턴. 작은 사이즈 = 1, 큰 사이즈 = 2
  final type = size;
  final double thisWidth = MediaQuery.of(context).size.width;
  return Stack(children: [
    Container(
      width: type == 1 ? 180 : thisWidth * 0.8, // 화면 가로 길이의 4/5
      height:
          type == 1 ? 240 : thisWidth * 1.07, // 타일이 가로 세로 비율 3:4를 갖도록 세로 길이 계산
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageURL),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15)),
      ),
    ),
    Container(
      width: type == 1 ? 180 : thisWidth * 0.8, // 화면 가로 길이의 4/5
      height:
          type == 1 ? 240 : thisWidth * 1.07, // 타일이 가로 세로 비율 3:4를 갖도록 세로 길이 계산
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(subCategory,
                  style: const TextStyle(color: Colors.white, height: 1.5)),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: '난이도 ',
                    style: TextStyle(color: Colors.white, height: 1.5)),
                TextSpan(
                    text: level,
                    style: TextStyle(
                        color: myColor.shade100,
                        fontWeight: FontWeight.w600,
                        height: 1.5))
              ])),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: type == 1 ? 16 : 20,
                    height: 1.5),
              ),
            ],
          ),
        ),
      ),
    ),
  ]);
}
