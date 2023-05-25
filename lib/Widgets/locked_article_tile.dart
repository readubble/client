import 'package:flutter/material.dart';

Widget lockedArticleTile(BuildContext context, String imageURL,
    String subCategory, String level, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('잠깐!'),
              content: const Text('아직은 이 글을 볼 수 없어요!'),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    '확인',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        },
      );
    },
    child: Stack(children: [
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
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
      const Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Icon(
          Icons.lock,
          color: Colors.white,
          size: 40,
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
              Text("난이도 $level", style: const TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.4),
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}
