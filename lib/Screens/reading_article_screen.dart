import 'package:bwageul/Models/article_and_quiz.dart';
import 'package:bwageul/Providers/problem_info_provider.dart';
import 'package:bwageul/Providers/quiz_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../EyetrackingUI/calibration_widget.dart';
import '../EyetrackingUI/gaze_point_widget.dart';
import '../EyetrackingUI/initialized_fail_dialog_widget.dart';
import '../EyetrackingUI/loading_circle_widget.dart';
import '../Models/app_stage.dart';
import '../Providers/gaze_tracker_provider.dart';
import '../Providers/problem_id_provider.dart';
import '../Services/api_services.dart';
import '../Services/storage.dart';
import '../main.dart';
import 'bottom_summary_sheet.dart';

class ReadingArticleScreen extends StatefulWidget {
  const ReadingArticleScreen({Key? key}) : super(key: key);

  @override
  State<ReadingArticleScreen> createState() => _ReadingArticleScreenState();
}

class _ReadingArticleScreenState extends State<ReadingArticleScreen> {
  double baseFontSize = 18;
  String thisText = '';
  ArticleAndQuiz info = ArticleAndQuiz(
      problem: ProblemInfo(title: '', content: [], level: '', author: ''),
      quizList: [
        QuizInfo(
          problem: '문제',
          choices: [],
          answer: 1,
        )
      ]); // 디폴트 객체
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print(
          'offset = ${_scrollController.offset}'); // Sliding distance. 스크롤바의 위치
    });
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   // 페이지가 로드된 후 즉시 alertDialog를 표시합니다.
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('타이머 시작'),
    //         content: Text(
    //           '시작 버튼을 누르면 타이머가 시작됩니다.',
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: Text(
    //               '시작',
    //               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
    //             ),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // });
    _loadArticleContents();
    thisText = makeText(info.problem.content);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadArticleContents() async {
    if (await isLoggedIn()) {
      final problemIdProvider =
          Provider.of<ProblemIdProvider>(context, listen: false);
      final problemId = problemIdProvider.problemId;

      ArticleAndQuiz model = await ApiService.fetchArticleContents(problemId!);
      final problemProvider =
          Provider.of<ProblemInfoProvider>(context, listen: false);
      problemProvider.setProblemInfo(model.problem);
      final quizProvider =
          Provider.of<QuizListProvider>(context, listen: false);
      quizProvider.setQuizList(model.quizList);
      setState(() {
        info = model;
        thisText = makeText(info.problem.content);
      });
    }
  } // 글에 대한 정보를 가져옴.

  String makeText(List<List<String>> lst) {
    String txt = ' ';

    for (int i = 0; i < lst.length; i++) {
      if (lst[i].length > 0) {
        for (int j = 0; j < lst[i].length; j++) {
          txt += lst[i][j];
        }
      } else {
        txt += '\n';
      }
    }

    return txt;
  } // 2차원 배열로 들어오는 글을 잘라서 보여주기

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 70),
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
                            info.problem.title,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                height: 1.4),
                          ), //글 제목
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
                                info.problem.level,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: myColor.shade300,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ), //난이도
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            height: 2,
                            color: Colors.black,
                          ), // 가로줄
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
                                  )), // 국어사전 버튼
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
                                            fontFamily: 'lottedream',
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
                            style: TextStyle(
                                fontFamily: 'Jeju',
                                fontSize: baseFontSize,
                                height: 1.7),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomSummarySheet(), // 하단 퀴즈, 글 요약하는 창
            if (consumer.state == GazeTrackerState.start)
              const GazePointWidget(),
            if (consumer.state == GazeTrackerState.initializing)
              const LoadingCircleWidget(),
            if (consumer.state == GazeTrackerState.calibrating)
              const CalibrationWidget(),
            if (consumer.failedReason != null) const InitializedFailDialog()
          ]),
        ));
  }
}
