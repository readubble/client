import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Services/api_services.dart';
import '../Models/user_info_provider.dart';
import '../main.dart';

class FinishReading extends StatefulWidget {
  const FinishReading({Key? key}) : super(key: key);

  @override
  State<FinishReading> createState() => _FinishReadingState();
}

class _FinishReadingState extends State<FinishReading> {
  String nickname = '';
  List<dynamic> keywordList = [];
  List<dynamic> sentenceList = [];
  String summarization = '';
  String aiSummarization = "";
  bool isLiked = false;
  String level = '';
  String title = '';
  int problemId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadData() {
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    nickname = userInfoProvider.user!.nickname;
    final arguments = ModalRoute.of(context)
        ?.settings
        .arguments; // pushNamed 인자로 받아온 aiSummarization
    if (arguments is Map<String, dynamic>) {
      setState(() {
        title = arguments['title'];
        aiSummarization = arguments['ai_summarization'];
        summarization = arguments['my_summarization'];
        level = arguments['level'];
        keywordList = arguments['keyword_list'];
        sentenceList = arguments['key_sentences'];
        isLiked = (arguments['save_fl'] == "Y") ? true : false;
        problemId = arguments['problem_id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 35,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                      onPressed: () async {
                        final arguments = ModalRoute.of(context)
                            ?.settings
                            .arguments as Map<String, dynamic>;
                        setState(() {
                          isLiked = !isLiked;
                          (arguments['save_fl'] == 'Y')
                              ? arguments['save_fl'] = 'N'
                              : arguments['save_fl'] = 'Y';
                        });
                        await ApiService.problemBookmark(problemId);
                      },
                      icon: isLiked
                          ? Icon(
                              Icons.favorite_rounded,
                              size: 35,
                              color: myColor.shade300,
                            )
                          : Icon(
                              Icons.favorite_border_rounded,
                              size: 35,
                              color: myColor.shade300,
                            )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
                          level,
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
                              // Navigator.popUntil(
                              //     context,
                              //     ModalRoute.withName(
                              //         '/article')); // 글 읽기 시작하는 화면으로 돌아감
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/'),
                              ); // 앞에 쌓인 페이지 다 치우고 글 읽는 화면으로 이동
                              Navigator.pushNamed(
                                context,
                                '/article',
                                arguments: problemId, // 전달할 int 인자
                              );
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
                                  "다시 풀기",
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
                    // Row(
                    //   children: [
                    //     Icon(Icons.timer_outlined),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Text(
                    //       "소요 시간: 몇 분 몇 초",
                    //       style: TextStyle(
                    //           fontSize: 18,
                    //           height: 1.7,
                    //           fontWeight: FontWeight.w600),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Text(
                      "[ $nickname님이 정리한 결과 ]",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                              itemCount:
                                  keywordList != null ? keywordList.length : 0,
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
                            itemCount:
                                sentenceList != null ? sentenceList.length : 0,
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
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: myColor.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  summarization,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
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
                          height: 250,
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: myColor.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  aiSummarization,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
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
                              // context, ModalRoute.withName('/'));
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
      )),
    );
  }
}
