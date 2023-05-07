import 'dart:ui';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nickname = '홍길동';
  int days = 100;
  final PageController _quizController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              // 앱명 + 000님은 000일째 성장 중!
              children: [
                const Text(
                  '봐글봐글',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  '$nickname님은 봐글봐글과 함께\n$days일째 성장 중!',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Container(
              // 가로줄
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              height: 2,
              color: myColor.shade700,
            ),
            Container(
              // 문해력 퀴즈
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: myColor.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: myColor.shade800,
                      blurRadius: 5,
                      offset: const Offset(5, 5),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: PageView(
                  controller: _quizController,
                  children: <Widget>[
                    buildEachQuiz("1. '어디에다'의 준말로 옳은 것은?", '어따', '얻다'),
                    buildEachQuiz("2. 과자 먹어도 (   )?", "돼", "되"),
                    buildEachQuiz("3. 한 시간 (       ) 만나자.", "이따가", "있다가"),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SmoothPageIndicator(
              controller: _quizController,
              count: 3,
              effect: JumpingDotEffect(
                activeDotColor: myColor.shade100,
                dotColor: myColor.shade700,
                dotHeight: 12,
                dotWidth: 12,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "인문 카테고리",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            SingleChildScrollView(
              //인문 카테고리 글 모음
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/startReading');
                    },
                    child: unlockedArticleTile(
                        'assets/images/hum1.jpeg', "예술", "중", "브람스 교향곡 4번"),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/hum2.png', '철학',
                      '상', '호모 루덴스와 호모 파베르, 그리고 호모 파덴스'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(
                      context, 'assets/images/hum3.png', '철학', '상', '칸트의 시간이론'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/hum4.png', '역사',
                      '중', '정약용의 다산초당'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/hum5.png', '미술',
                      '하', '프리다 칼로의 삶'),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "사회 카테고리",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            SingleChildScrollView(
              //사회 카테고리 글 모음
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/startReading');
                      },
                      child: unlockedArticleTile('assets/images/soc1.png', '사회',
                          '중', '법무부 ‘제시카법’은 성범죄만…강력범죄 피해자 보호는 구멍')),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/soc2.png', '경제',
                      '상', '‘최대주주 지배력 강화 막아라’…전환우선주도 콜옵션 규제 적용'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/soc1.png', '경제',
                      '상', '‘최대주주 지배력 강화 막아라’…전환우선주도 콜옵션 규제 적용'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/soc2.png', '경제',
                      '상', '‘최대주주 지배력 강화 막아라’…전환우선주도 콜옵션 규제 적용'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(context, 'assets/images/soc1.png', '경제',
                      '상', '‘최대주주 지배력 강화 막아라’…전환우선주도 콜옵션 규제 적용'),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "과학·기술 카테고리",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            SingleChildScrollView(
              //사회 카테고리 글 모음
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/startReading');
                      },
                      child: unlockedArticleTile('assets/images/sci1.png', 'IT',
                          '중', 'AI의 등장에 따른 윤리적 문제')),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(
                      context, 'assets/images/sci2.jpeg', '물리', '상', '빅뱅 우주론'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(
                      context, 'assets/images/sci2.jpeg', '물리', '상', '빅뱅 우주론'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(
                      context, 'assets/images/sci2.jpeg', '물리', '상', '빅뱅 우주론'),
                  const SizedBox(
                    width: 15,
                  ),
                  lockedArticleTile(
                      context, 'assets/images/sci2.jpeg', '물리', '상', '빅뱅 우주론'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildEachQuiz(String question, String ans1, String ans2) {
  // 퀴즈 만드는 함수: 퀴즈제목, 보기1, 보기2
  return Column(
    children: [
      Text(
        question,
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 1)
            ]),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: myColor.shade800,
              elevation: 5,
              minimumSize: const Size(120, 50),
              maximumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Text(
              ans1,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: myColor.shade800,
              elevation: 5,
              minimumSize: const Size(120, 50),
              maximumSize: const Size(150, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Text(
              ans2,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ],
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
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}
