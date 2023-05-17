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
            child: unlockedArticleTile(
              article.photo,
              article.genre,
              article.difficulty,
              article.title,
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ]);
      },
    ),
  );
}

Widget unlockedArticleTile(
    String imageURL, String subCategory, String level, String title) {
  // 각 글(타일)을 리턴
  return Stack(children: [
    Container(
      width: 180,
      height: 240,
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
    SizedBox(
      width: 180,
      height: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(subCategory, style: const TextStyle(color: Colors.white)),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '난이도 ', style: const TextStyle(color: Colors.white)),
              TextSpan(
                  text: level,
                  style: TextStyle(
                      color: myColor.shade100, fontWeight: FontWeight.w600))
            ])),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 160,
              child: Text(
                title,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  ]);
}
