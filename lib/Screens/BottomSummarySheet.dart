import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class BottomSummarySheet extends StatefulWidget {
  const BottomSummarySheet({Key? key}) : super(key: key);

  @override
  State<BottomSummarySheet> createState() => _BottomSummarySheetState();
}

class _BottomSummarySheetState extends State<BottomSummarySheet>
    with SingleTickerProviderStateMixin {
  final String nickname = '홍길동';
  final PageController _pageController = PageController(initialPage: 0);

  List<int> chosenAnswer = [0, 0, 0]; //총 3문제
  Map<String, List<String>> choices = {
    "quiz1": ["바로 다음의 해", "올해", "지난해"],
    "quiz2": ["하이든", "바흐", "베토벤"],
    "quiz3": ["O", "X", "알 수 없음"]
  };

  static const List<Tab> myTabs = <Tab>[
    Tab(text: '키워드'),
    Tab(text: '주제문'),
    Tab(text: '요약문'),
  ];

  late TabController _tabController;

  int _rowsCount = 1;
  List<TextEditingController> _textEditingControllers = [];
  TextEditingController _summaryTextEditingController = TextEditingController();

  final List<String> _articleSentences = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit Sed non risus.',
    'Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.',
    'Cras elementum ultrices diam Maecenas ligula massa, varius a, semper congue, euismod non, mi.',
    'Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat.',
    'Duis semper Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim.',
    'Pellentesque congue Ut in risus volutpat libero pharetra tempor.',
    'Cras vestibulum bibendum augue Praesent egestas leo in pede Praesent blandit odio eu enim.',
    'Pellentesque sed dui ut augue blandit sodales.',
    'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh.',
    'Mauris ac mauris sed pede pellentesque fermentum.',
    'Maecenas adipiscing ante non diam sodales hendrerit.',
    'Ut velit mauris, egestas sed, gravida nec, ornare ut, mi.',
  ];
  late List<bool> isSelected; // 각 문장이 선택되었는지 true/false

  void _addRow() {
    setState(() {
      if (_rowsCount < 3) {
        _textEditingControllers.add(TextEditingController());
        _rowsCount++;
      }
    });
  }

  void _removeRow(int index) {
    setState(() {
      _textEditingControllers.removeAt(index);
      _rowsCount--;
    });
  }

  void _copyText() {
    //_summaryTextEditingController.text += "THIS TEXT";
  }

  void updateSelection(int index) {
    setState(() {
      isSelected[index] = !isSelected[index];
    });
  }

  List<Widget> getElevatedButtonList() {
    List<Widget> buttonList = [];

    for (int i = 0; i < _articleSentences.length; i++) {
      Container button = Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              updateSelection(i);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSelected[i] ? myColor.shade50 : myColor.shade700,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(_articleSentences[i], style: TextStyle(fontSize: 16)),
          ));

      buttonList.add(button);
    }
    return buttonList;
  }

  List<Widget> getTopicSentences() {
    List<Widget> sentencesTile = [];

    for (int i = 0; i < _articleSentences.length; i++) {
      if (isSelected[i]) {
        Container button = Container(
          margin: EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: myColor.shade700,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _copyText,
            child: Container(
              child: Text(
                _articleSentences[i],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );

        sentencesTile.add(button);
      }
    }
    return sentencesTile;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _textEditingControllers.add(TextEditingController());
    isSelected = List.generate(_articleSentences.length, (_) => false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textEditingControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
              decoration: BoxDecoration(
                  color: Colors.white, // 배경 색상
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 10)
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
                        Text(
                          "내용 정리하기",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 22),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "[문제 1]",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "‘이듬해’와 같은 뜻의 단어를 고르세요.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RadioListTile(
                            title: Text(
                              choices["quiz1"]![0],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 1,
                            groupValue: chosenAnswer[0],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[0] = value!;
                              });
                            }),
                        RadioListTile(
                            title: Text(
                              choices["quiz1"]![1],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 2,
                            groupValue: chosenAnswer[0],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[0] = value!;
                              });
                            }),
                        RadioListTile(
                            title: Text(
                              choices["quiz1"]![2],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 3,
                            groupValue: chosenAnswer[0],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[0] = value!;
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade100,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: Icon(
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
                        ),
                      ),
                      Expanded(
                        child:
                            TabBarView(controller: _tabController, children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '이 글에서 키워드라고 생각하는 단어를 적어주세요! (최대 3개)',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
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
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 25),
                                              ),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      _textEditingControllers[
                                                          index],
                                                  decoration: InputDecoration(
                                                    hintText: '키워드 입력',
                                                    border:
                                                        UnderlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              if (isLastRow)
                                                IconButton(
                                                  onPressed: _addRow,
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 25,
                                                  ),
                                                ),
                                              if (!isLastRow)
                                                IconButton(
                                                  onPressed: () =>
                                                      _removeRow(index),
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: 25,
                                                  ),
                                                ),
                                            ],
                                          );
                                        }).toList().cast<Widget>(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _pageController.previousPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: myColor.shade800,
                                              foregroundColor: Colors.white,
                                              shadowColor: myColor.shade800,
                                              elevation: 4),
                                          child: Icon(
                                            Icons.arrow_back_rounded,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(
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
                                          child: Icon(
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
                          ), // 키워드 탭
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '주제문이라고 생각하는 문장들을 선택해주세요.',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(children: getElevatedButtonList()),
                                    SizedBox(
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
                                          child: Icon(
                                            Icons.arrow_back_rounded,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(
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
                                          child: Icon(
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
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      children: getTopicSentences(),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '위 주제문을 참고해보세요!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: _summaryTextEditingController,
                                      maxLines: 10,
                                      decoration: InputDecoration(
                                        hintText: '요약문을 작성해주세요.',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
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
                                          child: Icon(
                                            Icons.arrow_back_rounded,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            _pageController.nextPage(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: myColor.shade100,
                                              foregroundColor: Colors.white,
                                              shadowColor: myColor.shade800,
                                              elevation: 4),
                                          child: Icon(
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
                        Text(
                          "[문제 2]",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "교향곡을 공개할 때마다 ‘이 작곡가’와 유사하다는 비판을 받던 브람스는 4번째 교향곡에서 진정한 자신만의 교향곡 모델을 만들었다는 평가를 받았습니다. ‘이 작곡가’는 누구일까요?",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RadioListTile(
                            title: Text(
                              choices["quiz2"]![0],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 1,
                            groupValue: chosenAnswer[1],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[1] = value!;
                              });
                            }),
                        RadioListTile(
                            title: Text(
                              choices["quiz2"]![1],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 2,
                            groupValue: chosenAnswer[1],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[1] = value!;
                              });
                            }),
                        RadioListTile(
                            title: Text(
                              choices["quiz2"]![2],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 3,
                            groupValue: chosenAnswer[1],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[1] = value!;
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade800,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 25,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myColor.shade100,
                                  foregroundColor: Colors.white,
                                  shadowColor: myColor.shade800,
                                  elevation: 4),
                              child: Icon(
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
                        Text(
                          "[문제 3]",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "브람스는 자신의 교향곡 4번을 마이닝겐에서 처음 공개하던 때, 직접 지휘했다.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RadioListTile(
                            title: Text(
                              choices["quiz3"]![0],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 1,
                            groupValue: chosenAnswer[2],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[2] = value!;
                              });
                            }),
                        RadioListTile(
                            title: Text(
                              choices["quiz3"]![1],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 2,
                            groupValue: chosenAnswer[2],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[2] = value!;
                              });
                            }),
                        RadioListTile(
                            title: Text(
                              choices["quiz3"]![2],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: 3,
                            groupValue: chosenAnswer[2],
                            onChanged: (value) {
                              setState(() {
                                chosenAnswer[2] = value!;
                              });
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/finish');
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
