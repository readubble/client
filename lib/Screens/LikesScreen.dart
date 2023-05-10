import 'package:flutter/material.dart';
import '../main.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  static const List<Tab> myTabs = <Tab>[
    Tab(
      child: Text('저장한 글', style: TextStyle(fontSize: 18)),
    ),
    Tab(
      child: Text('저장한 단어', style: TextStyle(fontSize: 18)),
    )
  ];
  int articleCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              TabBar(controller: _tabController, tabs: myTabs),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('clicked!');
                              },
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: myColor.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                              color: myColor.shade800,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.psychology_rounded,
                                          size: 80,
                                          color: Colors.white)),
                                  const Text(
                                    '인문',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ), // 인문 버튼
                            GestureDetector(
                              onTap: () {
                                print('clicked!');
                              },
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: myColor.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                              color: myColor.shade800,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.groups_outlined,
                                          size: 80, color: Colors.white)),
                                  const Text(
                                    '사회',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ), //사회 버튼
                            GestureDetector(
                              onTap: () {
                                print('clicked!');
                              },
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: myColor.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                              color: myColor.shade800,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.science_outlined,
                                          size: 80, color: Colors.white)),
                                  const Text(
                                    '과학',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ), //과학 버튼
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ' 저장한 글($articleCount 개)',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  '모두 보기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ))
                          ],
                        ), //'저장한 글' 텍스트
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: GridView.count(
                            shrinkWrap: true,
                            primary: false,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 3,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: const Text(
                                    "He'd have you all unravel at the"),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[200],
                                child: const Text('Heed not the rabble'),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[100],
                                child: const Text(
                                    "He'd have you all unravel at the"),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[200],
                                child: const Text('Heed not the rabble'),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[300],
                                child: const Text('Sound of screams but the'),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[400],
                                child: const Text('Who scream'),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[500],
                                child: const Text('Revolution is coming...'),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                color: Colors.teal[600],
                                child: const Text('Revolution, they...'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Center(
                    child: Text("단어단어", style: TextStyle(fontSize: 40)),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
