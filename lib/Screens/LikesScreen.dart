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
  String category = '';

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
                                setState(() {
                                  category = '[인문]';
                                });
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
                                setState(() {
                                  category = '[사회]';
                                });
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
                                setState(() {
                                  category = '[과학]';
                                });
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
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text: ' $category ',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightBlue),
                              ),
                              TextSpan(
                                text: '저장한 글 ($articleCount 개)',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ])),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    category = '';
                                  });
                                },
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
                            children: getLikedArticles(),
                          ),
                        ),
                      ],
                    ),
                  ), //저장한 글
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' 나의 단어장',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
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
                            childAspectRatio: 2,
                            children: getLikedWords(),
                          ),
                        ),
                      ],
                    ),
                  ), //저장한 단어
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> getLikedArticles() {
  List<Widget> articles = [];

  for (int i = 0; i < 10; i++) {
    articles.add(Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[200],
      child: const Text('Heed not the rabble'),
    ));
  }

  return articles;
} // 저장한 글의 리스트를 타일 형태로 반환하는 메소드. 좋아요 표시 된 UnlockedArticleTile을 articles[]에 추가할 것.
// 매개변수로 글의 카테고리를 받고, 그때 그때 카테고리에 따라 저장한 글을 가져오면 좋겠음

List<Widget> getLikedWords() {
  List<Widget> words = [];

  for (int i = 0; i < 10; i++) {
    words.add(Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.teal.shade100),
      padding: const EdgeInsets.all(8),
      child: const Text(
        '대외비',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ));
  }

  return words;
}
