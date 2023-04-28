import 'package:bwageul/Widgets/SwipeGuide.dart';
import 'package:flutter/material.dart';

class ReadingThumbnailScreen extends StatefulWidget {
  const ReadingThumbnailScreen({Key? key}) : super(key: key);

  @override
  State<ReadingThumbnailScreen> createState() => _ReadingThumbnailScreenState();
}

class _ReadingThumbnailScreenState extends State<ReadingThumbnailScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.direction > 0) {
          // <- 방향 스로이프 시 다음 단계로 넘어감
          Navigator.of(context).pushNamed('/article');
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                    image: AssetImage('assets/images/hum1.jpeg'),
                    fit: BoxFit.fitHeight,
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("예술",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      Text("난이도 상",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Text(
                          "브람스 교향곡 4번",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  right: 5,
                  child: Center(child: SwipeGuide(text: '왼쪽으로 넘겨서\n글 읽기'))),
            ]),
          ),
        ),
      ),
    );
  }
}
