import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';

import '../Widgets/swipe_guide.dart';

class ReadingThumbnailScreen extends StatefulWidget {
  const ReadingThumbnailScreen({Key? key}) : super(key: key);

  @override
  State<ReadingThumbnailScreen> createState() => _ReadingThumbnailScreenState();
}

class _ReadingThumbnailScreenState extends State<ReadingThumbnailScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.direction > 0) {
          // <- 방향 스와이프 시 다음 단계로 넘어감
          Navigator.of(context)
              .pushNamed('/article', arguments: arguments['problemId']);
        }
      },
      child: Scaffold(
        body: Center(
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                image: DecorationImage(
                  image: NetworkImage(arguments['photo']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            SizedBox(
              //하위 카테고리, 난이도, 글 제목
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(arguments['genre'],
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(text: "난이도 ", style: TextStyle(fontSize: 20)),
                      TextSpan(
                          text: arguments['difficulty'],
                          style: TextStyle(
                              color: myColor.shade100,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))
                    ])),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      arguments['title'],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(arguments['writer'],
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 15,
                            height: 1.5)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 15,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Positioned(
                top: 0,
                bottom: 0,
                right: 5,
                child: Center(child: SwipeGuide(text: '왼쪽으로 넘겨서\n글 읽기'))),
          ]),
        ),
      ),
    );
  }
}
