import 'package:bwageul/Models/article_bookmark_model.dart';
import 'package:bwageul/Models/reading_result_model.dart';
import 'package:bwageul/Models/word_bookmark_model.dart';
import 'package:flutter/material.dart';
import '../Services/api_services.dart';
import '../Widgets/unlocked_article_tile.dart';
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
      child: Text('저장한 글',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    ),
    Tab(
      child: Text('저장한 단어',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    )
  ];
  int articleCount = 0; // 현재 카테고리의 북마크된 글 개수
  int wordCount = 0;
  List<ArticleBookmarkModel> resultDataList = [];
  List<WordBookmarkModel> wordDataList = [];
  int catNo = 1;
  List<bool> likes = []; // 단어장 추가 T/F

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData(catNo);
    loadWord();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData(int no) async {
    final data = await ApiService.getProblemBookmarkList(no);
    if (mounted) {
      setState(() {
        resultDataList = data;
        articleCount = resultDataList.length;
      });
    }
  } // 북마크된 글 정보 불러오기

  Future<void> loadWord() async {
    final data = await ApiService.getWordBookmarkList();
    if (mounted) {
      setState(() {
        wordDataList = data;
        wordCount = wordDataList.length;
        likes = data.map((e) => true).toList();
      });
    }
  } // 북마크된 단어 정보 불러오기

  List<Widget> getLikedArticles() {
    List<Widget> articles = [];
    for (int i = 0; i < resultDataList.length; i++) {
      articles.add(GestureDetector(
        onTap: () async {
          ReadingResultModel model =
              await ApiService.articleReadingResult(resultDataList[i].id);
          Navigator.of(context).pushNamed('/finish', arguments: {
            'ai_summarization': model.aiSummarization,
            'title': resultDataList[i].atcTitle,
            'level': resultDataList[i].difficulty,
            'keyword_list': model.keywords,
            'key_sentences': model.sentence,
            'my_summarization': model.summarization,
            'save_fl': model.saveFl,
            'problem_id': model.problemId,
          }); // 북마크 글에어 문제 풀이 결과 정보를 넘겨줘야 finishReading 스크린에 그릴 수 있음.
        },
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: unlockedArticleTile(
                context,
                resultDataList[i].atcPhotoIn,
                resultDataList[i].genre,
                resultDataList[i].difficulty,
                resultDataList[i].atcTitle,
                2),
          ),
        ),
      ));
    }
    return articles;
  } // 저장한 글의 리스트를 타일 형태로 반환하는 메소드. 좋아요 표시 된 UnlockedArticleTile을 articles[]에 추가할 것.

  List<Widget> getLikedWords() {
    List<Widget> words = [];
    for (int i = 0; i < wordDataList.length; i++) {
      Container wordInfo = Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: myColor.shade700,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: myColor.shade800,
              blurRadius: 3,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  wordDataList[i].wordNm,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      likes[i] = !likes[i];
                    });
                    await ApiService.wordBookmark(
                      wordDataList[i].targetCode,
                      wordDataList[i].wordNm,
                      wordDataList[i].wordMean,
                    );
                  },
                  icon: likes[i]
                      ? Icon(
                          Icons.favorite,
                          size: 25,
                          color: myColor.shade100,
                        )
                      : Icon(
                          Icons.favorite_outline_rounded,
                          size: 25,
                          color: myColor.shade100,
                        ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    wordDataList[i].wordMean, // 결과에서 뜻 가져오기
                    style: const TextStyle(fontSize: 17, height: 1.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      words.add(wordInfo);
    }

    return words;
  } // 북마크된 단어 리스트 가져오기

  @override
  Widget build(BuildContext context) {
    loadData(catNo);
    loadWord();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                                catNo = 1;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: myColor.shade700,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width / 3.7,
                              child: const Text(
                                '인문',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                catNo = 2;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: myColor.shade700,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width / 3.7,
                              child: const Text(
                                '사회',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                catNo = 3;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: myColor.shade700,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: MediaQuery.of(context).size.width / 3.7,
                              child: const Text(
                                '과학',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ), // 인문, 사회, 과학 버튼 리스트
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 10,
                        thickness: 1.5,
                        color: myColor.shade700,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: getLikedArticles(),
                        ),
                      ),
                    ],
                  ),
                ), //저장한 글
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' 나의 단어장',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        //'저장한 글' 텍스트
                        const SizedBox(
                          height: 20,
                        ),
                        ...getLikedWords(),
                      ],
                    ),
                  ),
                ), //저장한 단어
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
