import 'package:bwageul/Models/article_bookmark_model.dart';
import 'package:bwageul/Models/reading_result_model.dart';
import 'package:bwageul/Models/word_bookmark_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      child: Text('저장한 글', style: TextStyle(fontSize: 20)),
    ),
    Tab(
      child: Text('저장한 단어', style: TextStyle(fontSize: 20)),
    )
  ];
  int articleCount = 0;
  int wordCount = 0;
  String category = '[인문]'; // 기본값: 인문
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
    // 북마크된 글 정보 불러오기
    final data = await ApiService.getProblemBookmarkList(no);
    if (mounted) {
      setState(() {
        resultDataList = data;
        articleCount = resultDataList.length;
      });
    }
  }

  Future<void> loadWord() async {
    // 북마크된 단어 정보 불러오기
    final data = await ApiService.getWordBookmarkList();
    if (mounted) {
      setState(() {
        wordDataList = data;
        wordCount = wordDataList.length;
        likes = data.map((e) => true).toList();
      });
    }
  }

  List<Widget> getLikedWords() {
    List<Widget> words = [];

    for (int i = 0; i < wordDataList.length; i++) {
      Container wordInfo = Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: myColor.shade700,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: myColor.shade800,
              blurRadius: 3,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${wordDataList[i].wordNm}",
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      likes[i] = !likes[i];
                    });
                    // print(likes[i]);
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
                    style: TextStyle(fontSize: 17, height: 1.5),
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
  }

  @override
  Widget build(BuildContext context) {
    loadData(catNo);
    loadWord();

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
                                  catNo = 1;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: myColor.shade400,
                                        // color: Color(0xFF4B0082),
                                        boxShadow: [
                                          BoxShadow(
                                              color: myColor.shade400,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const FaIcon(
                                        // FontAwesomeIcons.userPen,
                                        FontAwesomeIcons.bookOpen,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                  // child: const Icon(Icons.book,
                                  //     size: 80, color: Colors.white)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    '인문',
                                    style: TextStyle(fontSize: 25),
                                  )
                                ],
                              ),
                            ), // 인문 버튼
                            // psychology_rounded
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  category = '[사회]';
                                  catNo = 2;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: myColor.shade200,
                                        boxShadow: [
                                          BoxShadow(
                                              color: myColor.shade800,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      // child: const FaIcon(
                                      //   FontAwesomeIcons.users,
                                      //   size: 50,
                                      //   color: Colors.white,
                                      // )),
                                      child:
                                          const Icon(Icons.diversity_3_outlined,
                                              //groups_outlined
                                              size: 70,
                                              color: Colors.white)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    '사회',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                            ), //사회 버튼
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  category = '[과학]';
                                  catNo = 3;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: myColor.shade600,
                                        boxShadow: [
                                          BoxShadow(
                                              color: myColor.shade800,
                                              blurRadius: 3,
                                              offset: const Offset(2, 2))
                                        ],
                                        shape: BoxShape.circle,
                                      ),
                                      child: const FaIcon(
                                        FontAwesomeIcons.flask,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                  // child: const Icon(Icons.science_outlined,
                                  //     size: 80, color: Colors.white)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    '과학',
                                    style: TextStyle(fontSize: 25),
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
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.lightBlue),
                              ),
                              TextSpan(
                                text: '저장한 글 (${resultDataList.length} 개)',
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ])),
                            // TextButton(
                            //     onPressed: () {
                            //       setState(() {
                            //         category = '';
                            //       });
                            //     },
                            //     child: const Text(
                            //       '모두 보기',
                            //       style: TextStyle(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ))
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
                            crossAxisCount: 2,
                            children: getLikedArticles(context, resultDataList),
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
                          Text(
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
                          // Expanded(
                          //   child: GridView.count(
                          //     shrinkWrap: true,
                          //     primary: false,
                          //     crossAxisSpacing: 10,
                          //     mainAxisSpacing: 10,
                          //     crossAxisCount: 2,
                          //     children: getLikedArticles(context, resultDataList),
                          //   ),
                          // ),
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
      ),
    );
  }
}

List<Widget> getLikedArticles(
    BuildContext context, List<ArticleBookmarkModel> resultDataList) {
  List<Widget> articles = [];

  for (int i = 0; i < resultDataList.length; i++) {
    articles.add(Container(
      child: GestureDetector(
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
          }); // 문제 풀이 결과 정보를 넘겨줘야 finishReading 스크린에 그릴 수 있음.
        },
        child: unlockedArticleTile(
            resultDataList[i].atcPhotoIn,
            resultDataList[i].genre,
            resultDataList[i].difficulty,
            resultDataList[i].atcTitle),
      ),
    ));
  }
  return articles;
} // 저장한 글의 리스트를 타일 형태로 반환하는 메소드. 좋아요 표시 된 UnlockedArticleTile을 articles[]에 추가할 것.
