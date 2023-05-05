import 'package:flutter/material.dart';

import '../main.dart';
import 'BottomSummarySheet.dart';

class ReadingArticleScreen extends StatefulWidget {
  const ReadingArticleScreen({Key? key}) : super(key: key);

  @override
  State<ReadingArticleScreen> createState() => _ReadingArticleScreenState();
}

class _ReadingArticleScreenState extends State<ReadingArticleScreen> {
  double baseFontSize = 18;
  String thisText = """
  \"거인이 내 뒤로 뚜벅뚜벅 쫓아오는 소리를 항상 들어야 한다고 생각해보게. 그때 그 기분을 자네는 전혀 상상할 수 없을 걸세.\" - 요하네스 브람스
  
  19세기의 다른 교향곡 작곡가들과 마찬가지로 브람스 역시 베토벤이라는 거인을 피해갈 수 없었다. 광대한 우주의 소리를 담아낸 베토벤의 교향곡이야말로 독일 교향곡의 모범답안으로 여겨지던 당대의 분위기에선 신작 교향곡이 나오면 곧바로 베토벤과 비교될 수밖에 없었다. 그러니 브람스가 그의 첫 번째 교향곡을 완성하기까지 무려 20여 년의 세월을 투자했던 것도 무리가 아니다.

 브람스의 첫 번째 교향곡은 유난히 베토벤의 교향곡을 닮았다. 이 곡에서 팀파니는 마치 베토벤의 [교향곡 제5번]의 ‘운명’의 동기를 닮은 리듬을 집요하게 반복한다. 그 때문에 당대의 뛰어난 피아니스트이나 지휘자이며 음악평론가인 한스 폰 뷜로는 브람스의 [교향곡 제1번]을 가리켜 ‘베토벤의 제10번’이라 불렀다. 이후 브람스는 교향곡 두 곡을 더 작곡했는데, 그 중 [교향곡 제2번]은 ‘브람스의 전원’, [제3번]은 ‘브람스의 영웅’에 비유되면서 여전히 베토벤의 교향곡과 유사하다는 혐의에서 벗어나지 못했다. 하지만 [교향곡 제4번]은 진정한 브람스만의 음악이며 아무도 이 교향곡을 베토벤의 작품에 빗대지 않았다.

 1885년, 이미 세 곡의 훌륭한 교향곡을 통해 교향곡 작곡가로서의 능력을 입증해낸 브람스는 이제 인생의 말년에 접어들어 자신만의 음악적 깊이를 교향곡에 담아내고자 그의 마지막 교향곡의 작곡에 심혈을 기울였다. 이 곡은 브람스의 단조 교향곡들 가운데 유일하게 피날레에서 장조의 환희로 변하지 않고 단조의 우울함을 그대로 간직하고 있다. 이로써 브람스는 ‘어둠에서 광명으로’ 향하는 베토벤 풍의 구도를 버리고 어둠으로부터 비극으로 침잠해 가는 자신만의 교향곡 모델을 확립하게 된 것이다.

 브람스의 [교향곡 4번]은 1885년 10월 25일에 마이닝겐에서 작곡가 자신의 지휘로 초연되었다. 초연 후 11년이 지난 1896년, 브람스는 교향곡 제4번의 악보를 펼치고 1악장의 첫 4음인 B-G-E-C 위에 “오! 죽음이여, 오 죽음이여!”라고 적었다. 그리고 이듬해, 브람스는 영원한 안식을 찾았다.
  """;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
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
                                fontSize: 28, fontWeight: FontWeight.w600),
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
                                    Navigator.of(context)
                                        .pushNamed('/dictionary');
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // BorderRadius 적용
                                    ),
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                height: 40,
                                width: 160,
                                decoration: BoxDecoration(
                                    color: myColor.shade700,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 3),
                                          blurRadius: 2,
                                          color: myColor.shade800)
                                    ]),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (baseFontSize > 13)
                                              baseFontSize -= 1;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.text_decrease_rounded,
                                          size: 25,
                                        )),
                                    Text("글자 크기",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (baseFontSize < 30)
                                              baseFontSize += 1;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.text_increase_rounded,
                                          size: 25,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            thisText,
                            style:
                                TextStyle(fontSize: baseFontSize, height: 1.7),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomSummarySheet(), // 하단 퀴즈, 글 요약하는 창
          ])),
    );
  }
}
