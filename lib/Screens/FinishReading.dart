import 'package:flutter/material.dart';

import '../main.dart';

class FinishReading extends StatefulWidget {
  const FinishReading({Key? key}) : super(key: key);

  @override
  State<FinishReading> createState() => _FinishReadingState();
}

class _FinishReadingState extends State<FinishReading> {
  final String nickname = '홍길동';

  final List<String> keywordList = ['키워드1', '키워드2', '키워드3'];

  final List<String> sentenceList = [
    '주제문1입니다.주제문1입니다.주제문1입니다.주제문1입니다.주제문1입니다.주제문1입니다.주제문1입니다.',
    '주제문2입니다.',
    '주제문3입니다.',
    '주제문4입니다.'
  ];

  final String summarization =
      '나는 글을 이렇게 요약하였다. 나는 글을 이렇게 요약하였다. 나는 글을 이렇게 요약하였다. 나는 글을 이렇게 요약하였다. 나는 글을 이렇게 요약하였다. ';
  final String aiSummarization =
      'AI는 글을 이렇게 요약하였다. AI는 글을 이렇게 요약하였다. AI는 글을 이렇게 요약하였다. AI는 글을 이렇게 요약하였다. AI는 글을 이렇게 요약하였다.';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 35,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Text(
                        "브람스 교향곡 4번",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "난이도 ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "중",
                            style: TextStyle(
                                fontSize: 16,
                                color: myColor.shade300,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // 가로줄
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        height: 2,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/article');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "원문 보기",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(110, 40),
                                backgroundColor: myColor.shade700,
                                foregroundColor: Colors.black,
                                primary: Colors.black.withOpacity(0.5),
                                elevation: 4,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // BorderRadius 적용
                                ),
                              )), // 원문보기 버튼
                          SizedBox(
                            width: 15,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/dictionary');
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "국어사전",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(110, 40),
                                backgroundColor: myColor.shade700,
                                foregroundColor: Colors.black,
                                primary: Colors.black.withOpacity(0.5),
                                elevation: 4,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // BorderRadius 적용
                                ),
                              )), // 국어사전 버튼
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "소요 시간: 몇 분 몇 초",
                            style: TextStyle(
                                fontSize: 18,
                                height: 1.7,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "[ $nickname님이 정리한 결과 ]",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                color: myColor.shade800,
                                size: 40,
                              ),
                              Text(
                                "키워드",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 130,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: myColor.shade700,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    thickness: 1,
                                    color: myColor.shade800,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return Text(
                                    "${index + 1}. ${keywordList[index]}",
                                    style: TextStyle(fontSize: 16),
                                  );
                                },
                                itemCount: keywordList.length,
                              )), //키워드
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                color: myColor.shade800,
                                size: 40,
                              ),
                              Text(
                                "주제문",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: myColor.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListView.separated(
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  thickness: 1,
                                  color: myColor.shade800,
                                );
                              },
                              itemBuilder: (context, index) {
                                return Text(
                                  "${index + 1}. ${sentenceList[index]}",
                                  style: TextStyle(fontSize: 16),
                                );
                              },
                              itemCount: sentenceList.length,
                            ),
                          ), //주제문
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                color: myColor.shade800,
                                size: 40,
                              ),
                              Text(
                                "요약문",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: myColor.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              summarization,
                              style: TextStyle(fontSize: 16),
                            ),
                          ), //요약문
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                color: myColor.shade800,
                                size: 40,
                              ),
                              Text(
                                "요약 결과 비교",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: myColor.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              aiSummarization,
                              style: TextStyle(fontSize: 16),
                            ),
                          ), //AI 요약문 비교
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.popUntil(
                                    context, ModalRoute.withName('/'));
                              },
                              child: Text(
                                "완료",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ), // 하단 퀴즈, 글 요약하는 창
      ])),
    );
  }
}
