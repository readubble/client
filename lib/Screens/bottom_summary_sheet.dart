import 'package:bwageul/Providers/problem_info_provider.dart';
import 'package:bwageul/Providers/quiz_list_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/problem_id_provider.dart';
import '../Providers/user_info_provider.dart';
import '../main.dart';
import 'package:bwageul/Models/article_and_quiz.dart';
import 'package:bwageul/Services/api_services.dart';

class BottomSummarySheet extends StatefulWidget {
  const BottomSummarySheet({Key? key}) : super(key: key);

  @override
  State<BottomSummarySheet> createState() => _BottomSummarySheetState();
}

class _BottomSummarySheetState extends State<BottomSummarySheet>
    with SingleTickerProviderStateMixin {
  String nickname = '';
  final PageController _pageController = PageController(initialPage: 0);
  List<String> _articleSentences = [];
  List<int> chosenAnswer = [0, 0, 0]; //총 3문제
  late TabController _tabController;
  List<bool> isSelected = []; // 각 문장이 선택되었는지 true/false
  late ProblemInfo problemInfo;
  String problemTitle = "";
  List<QuizInfo> quizInfoList = [];
  String aiSummarization = "";
  String level = "";
  List<bool> isAnswerPressed = List.generate(9, (index) => false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _textEditingControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textEditingControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void load_problem_quiz_info() {
    final problemProvider =
        Provider.of<ProblemInfoProvider>(context, listen: false);
    final quizProvider = Provider.of<QuizListProvider>(context, listen: false);
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);

    if (problemProvider.problemInfo != null &&
        (isSelected.isEmpty ||
            problemTitle != problemProvider.problemInfo!.title)) {
      problemTitle = problemProvider.problemInfo!.title;
      level = problemProvider.problemInfo!.level;
      _articleSentences =
          problemProvider.problemInfo!.content.expand((list) => list).toList();
      isSelected = List.generate(_articleSentences.length, (_) => false);
      problemInfo = problemProvider.problemInfo!;
      quizInfoList = quizProvider.quizList;
    }

    if (userInfoProvider.user != null) {
      setState(() {
        nickname = userInfoProvider.user!.nickname;
      });
    }
  } // 최초 1회 실행. wow... 문제 객체, 퀴즈 객체 초기화

  Future<void> fetchResult() async {
    List<String> keywords = ["", "", ""];
    for (int i = 0; i < _textEditingControllers.length; i++) {
      keywords[i] = _textEditingControllers[i].text;
    }
    String summarization = _summaryTextEditingController.text;
    List<int> choiceList = chosenAnswer;
    String sentences = ""; // 주제문
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i] == true) {
        sentences += "${_articleSentences[i]}|";
      }
    }
    List<String> resultList = [];
    for (int i = 0; i < choiceList.length; i++) {
      if (choiceList[i] == quizInfoList[i].answer) {
        resultList.add("Y");
      } else {
        resultList.add("N");
      }
    }
    final problemIdProvider =
        Provider.of<ProblemIdProvider>(context, listen: false);
    final problemId = problemIdProvider.problemId;
    final result = await ApiService.sendProblemSolved(
        keywords,
        sentences,
        summarization,
        choiceList,
        resultList,
        problemId!); // 문제 다 풀고 '완료' 버튼 누르면 서버로 결과 전송 & ai 요약 결과 가져옴.
    // Map<String, dynamic>으로, result['problem_id], result['ai_summarization']으로 받음
    aiSummarization = result['ai_summarization'];
  } // this bottom sheet에서 작성한 결과를 정리해서 서버에 보내는 작업.

  static List<Tab> myTabs = <Tab>[
    Tab(
      child: Text('키워드',
          style: TextStyle(shadows: [
            Shadow(
              color: Colors.grey.withOpacity(1),
              offset: const Offset(0, 1),
              blurRadius: 7,
            )
          ])),
    ),
    Tab(
      child: Text('주제문',
          style: TextStyle(shadows: [
            Shadow(
              color: Colors.grey.withOpacity(1),
              offset: const Offset(0, 1),
              blurRadius: 7,
            )
          ])),
    ),
    Tab(
      child: Text('요약문',
          style: TextStyle(shadows: [
            Shadow(
              color: Colors.grey.withOpacity(1),
              offset: const Offset(0, 1),
              blurRadius: 7,
            )
          ])),
    ),
  ];

  // 키워드 추가 부분
  int _rowsCount = 1;
  final List<TextEditingController> _textEditingControllers =
      []; // 키워드 작성 텍스트 컨트롤러
  final TextEditingController _summaryTextEditingController =
      TextEditingController(); // 요약문 작성 텍스트 컨트롤러

  void _addRow() {
    setState(() {
      if (_rowsCount < 3) {
        _textEditingControllers.add(TextEditingController());
        _rowsCount++;
      }
    });
  } // 키워드 칸 추가

  void _removeRow(int index) {
    setState(() {
      _textEditingControllers.removeAt(index);
      _rowsCount--;
    });
  } // 키워드 칸 삭제

  void updateSelection(int index) {
    setState(() {
      isSelected[index] = !isSelected[index];
    });
  } // 선택 여부 업데이트

  List<Widget> getElevatedButtonList() {
    List<Widget> buttonList = [];
    for (int i = 0; i < _articleSentences.length; i++) {
      Container button = Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              updateSelection(i);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected[i]
                  ? myColor.shade50
                  : myColor.shade700, // 선택되면 색상 바꾸기
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(_articleSentences[i],
                style: const TextStyle(fontSize: 16, height: 1.5)),
          ));

      buttonList.add(button);
    }
    return buttonList;
  } // 주제문 버튼 리스트

  List<Widget> getTopicSentences() {
    List<Widget> sentencesTile = [];
    for (int i = 0; i < _articleSentences.length; i++) {
      if (isSelected[i]) {
        Container button = Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: myColor.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              setState(() {
                _summaryTextEditingController.text +=
                    "${_articleSentences[i]} ";
              });
            },
            child: Container(
              child: Text(
                _articleSentences[i],
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        );

        sentencesTile.add(button);
      } // 눌렸으면 요약문 작성 탭에서 보이도록
    }
    return sentencesTile;
  } // 주제문 선택용 본문 텍스트 타일

  Widget problemOptionTiles(int pIdx) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 3, offset: Offset(1, 1))
              ],
              color: isAnswerPressed[3 * pIdx]
                  ? myColor.shade100
                  : Colors.grey.shade200),
          child: RadioListTile(
              title: Text(
                quizInfoList.isNotEmpty ? quizInfoList[pIdx].choices[0] : ' ',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              value: 1,
              groupValue: chosenAnswer[pIdx],
              onChanged: (value) {
                setState(() {
                  chosenAnswer[pIdx] = value! as int;
                  if (chosenAnswer[pIdx] == quizInfoList[pIdx].answer) {
                    isAnswerPressed[3 * pIdx] = true;
                  } else {
                    isAnswerPressed[3 * pIdx] = false;
                    isAnswerPressed[3 * pIdx + 1] = false;
                    isAnswerPressed[3 * pIdx + 2] = false;
                  }
                });
              }),
        ), // 첫번째 보기
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 3, offset: Offset(1, 1))
              ],
              color: isAnswerPressed[3 * pIdx + 1]
                  ? myColor.shade100
                  : Colors.grey.shade200),
          child: RadioListTile(
              title: Text(
                quizInfoList.isNotEmpty ? quizInfoList[pIdx].choices[1] : ' ',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              value: 2,
              groupValue: chosenAnswer[pIdx],
              onChanged: (value) {
                setState(() {
                  chosenAnswer[pIdx] = value! as int;
                  if (chosenAnswer[pIdx] == quizInfoList[pIdx].answer) {
                    isAnswerPressed[3 * pIdx + 1] = true;
                  } else {
                    isAnswerPressed[3 * pIdx] = false;
                    isAnswerPressed[3 * pIdx + 1] = false;
                    isAnswerPressed[3 * pIdx + 2] = false;
                  }
                });
              }),
        ), // 두번째 보기
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 3, offset: Offset(1, 1))
              ],
              color: isAnswerPressed[3 * pIdx + 2]
                  ? myColor.shade100
                  : Colors.grey.shade200),
          child: RadioListTile(
              title: Text(
                quizInfoList.isNotEmpty ? quizInfoList[pIdx].choices[2] : ' ',
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              value: 3,
              groupValue: chosenAnswer[pIdx],
              onChanged: (value) {
                setState(() {
                  chosenAnswer[pIdx] = value! as int;
                  if (chosenAnswer[pIdx] == quizInfoList[pIdx].answer) {
                    isAnswerPressed[3 * pIdx + 2] = true;
                  } else {
                    isAnswerPressed[3 * pIdx] = false;
                    isAnswerPressed[3 * pIdx + 1] = false;
                    isAnswerPressed[3 * pIdx + 2] = false;
                  }
                });
              }),
        ), // 세번째 보기
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    load_problem_quiz_info();
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              decoration: BoxDecoration(
                  color: Colors.white, // 배경 색상
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, -15),
                      blurRadius: 10,
                    )
                  ] // 둥근 모서리
                  ),
              child: PageView(
                controller: _pageController,
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "내용 정리하기",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "[문제 1]",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          quizInfoList.isNotEmpty
                              ? quizInfoList[0].problem
                              : ' ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              height: 1.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        problemOptionTiles(0), // 문제 1
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade100,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 25,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ), // 1번 문제
                  Column(
                    children: [
                      SingleChildScrollView(
                        controller: scrollController,
                        child: TabBar(
                          tabs: myTabs,
                          controller: _tabController,
                          onTap: (int index) {
                            FocusManager.instance.primaryFocus
                                ?.unfocus(); // 키보드 닫기 이벤트
                          },
                        ),
                      ),
                      Expanded(
                        child:
                            TabBarView(controller: _tabController, children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    '이 글에서 키워드라고 생각하는 단어를 적어주세요! (최대 3개)',
                                    style: TextStyle(
                                      fontSize: 17,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children:
                                          List.generate(_rowsCount, (index) {
                                        final isLastRow =
                                            (index == _rowsCount - 1);
                                        return Row(
                                          children: [
                                            Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 25),
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                controller:
                                                    _textEditingControllers[
                                                        index],
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: '키워드 입력',
                                                  border:
                                                      UnderlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (isLastRow)
                                              IconButton(
                                                onPressed: _addRow,
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 25,
                                                ),
                                              ),
                                            if (!isLastRow)
                                              IconButton(
                                                onPressed: () =>
                                                    _removeRow(index),
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 25,
                                                ),
                                              ),
                                          ],
                                        );
                                      }).toList().cast<Widget>(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .unfocus(); // 포커스 해제
                                          _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: myColor.shade800,
                                            foregroundColor: Colors.white,
                                            shadowColor: myColor.shade800,
                                            elevation: 4),
                                        child: const Icon(
                                          Icons.arrow_back_rounded,
                                          size: 25,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .unfocus(); // 포커스 해제
                                          final nextIndex =
                                              _tabController.index + 1;
                                          if (nextIndex <
                                              _tabController.length) {
                                            _tabController.animateTo(nextIndex);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: myColor.shade100,
                                            foregroundColor: Colors.white,
                                            shadowColor: myColor.shade800,
                                            elevation: 4),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ), // 키워드 탭
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '주제문이라고 생각하는 문장들을 선택해주세요.',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Column(children: getElevatedButtonList()),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            final previousIndex =
                                                _tabController.index - 1;
                                            if (previousIndex >= 0) {
                                              _tabController
                                                  .animateTo(previousIndex);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: myColor.shade800,
                                              foregroundColor: Colors.white,
                                              shadowColor: myColor.shade800,
                                              elevation: 4),
                                          child: const Icon(
                                            Icons.arrow_back_rounded,
                                            size: 25,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            final nextIndex =
                                                _tabController.index + 1;
                                            if (nextIndex <
                                                _tabController.length) {
                                              _tabController
                                                  .animateTo(nextIndex);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: myColor.shade100,
                                              foregroundColor: Colors.white,
                                              shadowColor: myColor.shade800,
                                              elevation: 4),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ), // 주제문 탭

                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Text(
                                        '$nickname님이 선택한 주제문',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      children: getTopicSentences(),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      '위 주제문을 참고해보세요!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _summaryTextEditingController,
                                      maxLines: 10,
                                      style: const TextStyle(height: 1.5),
                                      decoration: InputDecoration(
                                        hintText: '요약문을 작성해주세요.',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .unfocus(); // 포커스 해제
                                            final previousIndex =
                                                _tabController.index - 1;
                                            if (previousIndex >= 0) {
                                              _tabController
                                                  .animateTo(previousIndex);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: myColor.shade800,
                                              foregroundColor: Colors.white,
                                              shadowColor: myColor.shade800,
                                              elevation: 4),
                                          child: const Icon(
                                            Icons.arrow_back_rounded,
                                            size: 25,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .unfocus(); // 포커스 해제
                                            _pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: myColor.shade100,
                                              foregroundColor: Colors.white,
                                              shadowColor: myColor.shade800,
                                              elevation: 4),
                                          child: const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ), // 요약문 탭
                        ]),
                      )
                    ],
                  ), // 두번째 페이지(키워드,주제문,요약문)
                  SingleChildScrollView(
                    //2번 문제
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "[문제 2]",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          quizInfoList.isNotEmpty
                              ? quizInfoList[1].problem
                              : ' ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              height: 1.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        problemOptionTiles(1), // 문제 2
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade800,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade100,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 25,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ), // 2번 문제
                  SingleChildScrollView(
                    //3번 문제
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "[문제 3]",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          quizInfoList.isNotEmpty
                              ? quizInfoList[2].problem
                              : ' ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              height: 1.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        problemOptionTiles(2), // 문제 3
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade800,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_textEditingControllers.isEmpty ||
                                      _summaryTextEditingController.text ==
                                          "" ||
                                      isSelected.indexOf(true) == -1 ||
                                      chosenAnswer.indexOf(0) != -1) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("입력하지 않은 값이 있습니다."),
                                      duration: Duration(seconds: 2),
                                    ));
                                  } else {
                                    await fetchResult(); // 이 시트에서 쓴 내용 정리해서 서버에 전송.

                                    List<String> keySentences = [];
                                    for (int i = 0;
                                        i < isSelected.length;
                                        i++) {
                                      if (isSelected[i] == true) {
                                        keySentences.add(_articleSentences[i]);
                                      }
                                    }
                                    final problemIdProvider =
                                        Provider.of<ProblemIdProvider>(context,
                                            listen: false);
                                    final problemId = problemIdProvider
                                        .problemId; // 프로바이더로 pid 받아옴. 현재 읽고 있는 글의 pid를 다시 풀기 버튼에 대비하여 결과 화면에 보내줌.
                                    Navigator.of(context)
                                        .pushNamed('/finish', arguments: {
                                      'ai_summarization': aiSummarization,
                                      'title': problemTitle,
                                      'level': level,
                                      'keyword_list': _textEditingControllers
                                          .map((e) => e.text)
                                          .toList(),
                                      'key_sentences': keySentences,
                                      'my_summarization':
                                          _summaryTextEditingController.text,
                                      'save_fl': "N",
                                      'problem_id': problemId,
                                    }); // 바로 다음 페이지니까 서버 거치지 않고 바로 인자로 넘기기
                                  }
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
                  ), // 3번 문제
                ],
              ),
            ),
            Positioned(
                //가로줄
                top: 10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                          color: myColor.shade800,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}
