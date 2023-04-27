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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Container(
              // 가로줄
              margin: EdgeInsets.symmetric(vertical: 15),
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
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
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
                      Navigator.pushNamed(context, '/reading');
                    },
                    child: Stack(children: [
                      Container(
                        width: 180,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/hum1.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text("예술",
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("난이도 중",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  "브람스 교향곡 4번",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Stack(children: [
                    Container(
                      width: 180,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/images/hum2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Positioned(
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
                    Positioned(
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text("철학",
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("난이도 상",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                "호모 루덴스와 호모 파베르, 그리고 호모 파덴스",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/hum3.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/hum4.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/hum5.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "사회 카테고리",
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
                      Navigator.pushNamed(context, '/reading');
                    },
                    child: Stack(children: [
                      Container(
                        width: 180,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/soc1.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text("예술",
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("난이도 중",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 160,
                                child: Text(
                                  "브람스 교향곡 4번",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Stack(children: [
                    Container(
                      width: 180,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/images/soc2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Positioned(
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
                    Positioned(
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text("철학",
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("난이도 상",
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                "호모 루덴스와 호모 파베르, 그리고 호모 파덴스",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/hum3.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/hum4.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/images/hum5.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 200,
                  ),
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
                  offset: Offset(1, 1),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: myColor.shade800,
              elevation: 5,
              minimumSize: Size(120, 50),
              maximumSize: Size(150, 50),
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
