import 'package:bwageul/Models/article_and_quiz.dart';
import 'package:bwageul/Providers/problem_info_provider.dart';
import 'package:bwageul/Providers/quiz_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      problem: Article(title: '', content: [], level: '', author: ''),
      quizList: [
        Exercise(
          problem: '문제',
          choices: [],
          answer: 1,
        )
      ]);
  late ScrollController _scrollController;
  late ScrollController _scrollController2;

  bool seeResult = false;
  bool hasTrackingData = false;
  int circleRadius = 35;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController2 = ScrollController();

    _scrollController.addListener(_scrollListener);
    _scrollController2.addListener(_scrollListener);

    _loadArticleContents();
    thisText = makeText(info.problem.content);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController2.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (seeResult &&
        _scrollController.position.haveDimensions &&
        _scrollController2.position.haveDimensions) {
      double offset = _scrollController2.offset;
      _scrollController.jumpTo(offset);
    }
    Provider.of<GazeTrackerProvider>(context, listen: false)
        .setScrollOffset(_scrollController.offset);
  }

  Future<void> _loadArticleContents() async {
    if (await isLoggedIn()) {
      final problemIdProvider =
          Provider.of<ProblemIdProvider>(context, listen: false);
      final problemId = problemIdProvider.problemId;

      ArticleAndQuiz model =
          await ApiService.getArticleWithExercises(problemId!);
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
  }

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
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    double maxScrollExtent = 0.0;
    if (_scrollController.hasClients) {
      maxScrollExtent = _scrollController.position.maxScrollExtent;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
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
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 35,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Text(
                            info.problem.title,
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                height: 1.4),
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
                                info.problem.level,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: myColor.shade300,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ), //난이도
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            height: 2,
                            color: Colors.black,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/dictionary');
                                  },
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
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(110, 40),
                                    backgroundColor: myColor.shade700,
                                    foregroundColor: Colors.black,
                                    primary: Colors.black.withOpacity(0.5),
                                    elevation: 4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: myColor.shade700,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 3),
                                        blurRadius: 2,
                                        color: myColor.shade800,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (baseFontSize > 15) {
                                              baseFontSize -= 1;
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.text_decrease_rounded,
                                          size: 25,
                                        ),
                                      ),
                                      const Text(
                                        "글자 크기",
                                        style: TextStyle(
                                          fontFamily: 'lottedream',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (baseFontSize < 30) {
                                              baseFontSize += 1;
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.text_increase_rounded,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            thisText,
                            style: TextStyle(
                              fontFamily: 'Jeju',
                              fontSize: baseFontSize,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (consumer.state !=
                                      GazeTrackerState.start) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("시선 추적 중인 상태가 아닙니다."),
                                      duration: Duration(seconds: 2),
                                    ));
                                  } else {
                                    consumer.stopTracking();
                                    Provider.of<GazeTrackerProvider>(context,
                                            listen: false)
                                        .deinitGazeTracker();
                                    setState(() {
                                      hasTrackingData = true;
                                    });
                                  }
                                },
                                child: const Text(
                                  "추적 종료",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (hasTrackingData) {
                                      // 추적 결과가 있으면 결과를 보여줌
                                      _scrollController.jumpTo(0);
                                      seeResult = !seeResult;
                                    }
                                  });
                                },
                                child: const Text(
                                  "추적 결과",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (seeResult)
              GestureDetector(
                onTap: () {
                  setState(() {
                    seeResult = false;
                  });
                },
                child: SingleChildScrollView(
                  controller: _scrollController2,
                  child: SizedBox(
                    height:
                        maxScrollExtent + MediaQuery.of(context).size.height,
                    child: Stack(
                      children: consumer.topItems.map((item) {
                        int y = item[0]; // 행
                        int x = item[1]; // 열
                        return Positioned(
                          left: x * 30,
                          top: y * 30,
                          child: Container(
                            width: circleRadius * 2,
                            height: circleRadius * 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: myColor.shade50.withOpacity(0.5),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            const BottomSummarySheet(), // 하단 퀴즈, 글 요약하는 창
          ],
        ),
      ),
    );
  }
}
