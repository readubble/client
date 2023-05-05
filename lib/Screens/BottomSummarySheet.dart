import 'package:flutter/material.dart';
import '../main.dart';

class BottomSummarySheet extends StatefulWidget {
  const BottomSummarySheet({Key? key}) : super(key: key);

  @override
  State<BottomSummarySheet> createState() => _BottomSummarySheetState();
}

class _BottomSummarySheetState extends State<BottomSummarySheet>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;

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
                  color: myColor.shade600, // 배경 색상
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
                    //1번 문제
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
                        Container(
                          //스크롤 안내
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: myColor.shade800,
                                  offset: Offset(3, 3),
                                  blurRadius: 10,
                                )
                              ]),
                          width: 220,
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                color: myColor.shade800,
                                size: 30,
                              ),
                              Text(
                                " 스크롤하여 문제 이동 ",
                                style: TextStyle(color: myColor.shade800),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: myColor.shade800,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                      style: TextStyle(fontSize: 17),
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: Center(child: Text('Tab 2')),
                            ),
                          ),
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              child: Center(child: Text('Tab 3')),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
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
                      ],
                    ),
                  ),
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
                  ),
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
