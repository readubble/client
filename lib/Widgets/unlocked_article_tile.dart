import 'package:flutter/material.dart';

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
          image: AssetImage(imageURL),
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
            Text('난이도 $level', style: const TextStyle(color: Colors.white)),
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
