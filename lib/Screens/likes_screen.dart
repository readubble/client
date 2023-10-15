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
  int articleCount = -1; // 현재 카테고리의 북마크된 글 개수
  int wordCount = 0;
  List<ArticleBookmarkModel> resultDataList = [];
  List<WordBookmarkModel> wordDataList = [];
  int catNo = 1;
  List<bool> likes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadArticleData(catNo);
    loadWord();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadArticleData(int no) async {
    final data = await ApiService.getProblemBookmarks(no);
    if (mounted) {
      setState(() {
        resultDataList = data;
        articleCount = resultDataList.length;
      });
    }
  }

  Future<void> loadWord() async {
    final data = await ApiService.getWordBookmarks();
    if (mounted) {
      setState(() {
        wordDataList = data;
        wordCount = wordDataList.length;
        likes = data.map((e) => true).toList();
      });
    }
  }

  List<Widget> getLikedArticles() {
    List<Widget> articles = [];
    for (int i = 0; i < resultDataList.length; i++) {
      articles.add(GestureDetector(
        onTap: () async {
          ReadingResultModel model =
              await ApiService.getProblemResult(resultDataList[i].id);
          Navigator.of(context).pushNamed('/finish', arguments: {
            'ai_summarization': model.aiSummarization,
            'title': resultDataList[i].atcTitle,
            'level': resultDataList[i].difficulty,
            'keyword_list': model.keywords,
            'key_sentences': model.sentence,
            'my_summarization': model.summarization,
            'save_fl': model.saveFl,
            'problem_id': model.problemId,
          });
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
  }

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
                    await ApiService.updateWordBookmark(
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
  }

  @override
  Widget build(BuildContext context) {
    loadArticleData(catNo);
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.7,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  catNo = 1;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: myColor.shade700,
                              ),
                              child: const Text(
                                '인문',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.7,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  catNo = 2;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: myColor.shade700,
                              ),
                              child: const Text(
                                '사회',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.7,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  catNo = 3;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: myColor.shade700,
                              ),
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
                      if (articleCount == -1)
                        const Expanded(
                            child: Center(child: CircularProgressIndicator()))
                      else if (articleCount == 0)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sentiment_neutral_outlined,
                                  size: 100,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  '북마크한 글이 없어요!',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
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
                        const SizedBox(
                          height: 20,
                        ),
                        ...getLikedWords(),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
