import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Services/api_services.dart';
import '../Providers/problem_id_provider.dart';
import '../Providers/user_info_provider.dart';
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
    final arguments = ModalRoute.of(context)?.settings.arguments;
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
                    icon: const Icon(
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
                        await ApiService.updateProblemBookmark(problemId);
                      },
                      icon: isLiked
                          ? Icon(
                              Icons.favorite_rounded,
                              size: 35,
                              color: myColor.shade100,
                            )
                          : Icon(
                              Icons.favorite_border_rounded,
                              size: 35,
                              color: myColor.shade100,
                            )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          height: 1.5),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
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
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
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
                              Provider.of<ProblemIdProvider>(context,
                                      listen: false)
                                  .setProblemId(problemId);
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/main'),
                              );
                              Navigator.pushNamed(
                                context,
                                '/article',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(110, 40),
                              backgroundColor: myColor.shade700,
                              foregroundColor: Colors.black,
                              primary: Colors.black.withOpacity(0.5),
                              elevation: 4,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // BorderRadius 적용
                              ),
                            ),
                            child: Row(
                              children: const [
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
                            )), // 원문보기 버튼
                        const SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/dictionary');
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(110, 40),
                              backgroundColor: myColor.shade700,
                              foregroundColor: Colors.black,
                              primary: Colors.black.withOpacity(0.5),
                              elevation: 4,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: const [
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
                            )), // 국어사전 버튼
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "[ $nickname님이 정리한 결과 ]",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
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
                            const Text(
                              "키워드",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            height: 130,
                            padding: const EdgeInsets.symmetric(
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
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.5),
                                );
                              },
                              itemCount:
                                  keywordList != null ? keywordList.length : 0,
                            )), //키워드
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_outlined,
                              color: myColor.shade800,
                              size: 40,
                            ),
                            const Text(
                              "주제문",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          padding: const EdgeInsets.symmetric(
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
                                style:
                                    const TextStyle(fontSize: 16, height: 1.5),
                              );
                            },
                            itemCount: sentenceList.length != 0
                                ? sentenceList.length
                                : 0,
                          ),
                        ), //주제문
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_outlined,
                              color: myColor.shade800,
                              size: 40,
                            ),
                            const Text(
                              "요약문",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 200,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(
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
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ), //요약문
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_outlined,
                              color: myColor.shade800,
                              size: 40,
                            ),
                            const Text(
                              "요약 결과 비교",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 250,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(
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
                                  style: const TextStyle(
                                      fontSize: 16, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ), //AI 요약문 비교
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/main'));
                            },
                            child: const Text(
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
