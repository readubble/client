import 'dart:ui';
import 'package:bwageul/Services/api_services.dart';
import 'package:bwageul/Services/storage.dart';
import 'package:bwageul/Widgets/unlocked_article_tile.dart';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Models/article_info_model.dart';
import '../Models/user_info_provider.dart';
import '../Models/word_quiz_model.dart';
import '../Models/word_quiz_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _quizController = PageController(initialPage: 0);
  String nickname = '000';
  int days = 0;
  List<ArticleInfoModel> humArticleList = [];
  List<ArticleInfoModel> socArticleList = [];
  List<ArticleInfoModel> sciArticleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserInfo();
    _loadArticleList();
    //ApiService.articleContents(1); // 브람스 글 가져와
    //ApiService.dictionaryResult("나무");
  }

  Future<void> _loadArticleList() async {
    if (await isLoggedIn()) {
      List<ArticleInfoModel> list1 =
          await ApiService.fetchArticleList(1); // 1: 인문, 2: 사회, 3: 과학
      List<ArticleInfoModel> list2 = await ApiService.fetchArticleList(2);
      List<ArticleInfoModel> list3 = await ApiService.fetchArticleList(3);
      setState(() {
        humArticleList = list1;
        socArticleList = list2;
        sciArticleList = list3;
      });
    }
  }

  Future<void> _loadUserInfo() async {
    String? userId = await getUserId(); // 사용자 ID
    print('load user info -> userId : $userId');
    if (userId != null) {
      // 로그인된 경우

      var user = await ApiService.getUserInfoById(userId);
      final userInfoProvider =
          Provider.of<UserInfoProvider>(context, listen: false);
      userInfoProvider.setUser(user);

      setState(() {
        nickname = user.nickname;
        days = userInfoProvider.getDaysFromSignUp();
      });
    }
  }

  Future<List<Widget>> buildWordQuiz(BuildContext context) async {
    if (await isLoggedIn()) {
      // 로그인 된 경우에만 어휘 퀴즈 불러오기
      List<WordQuizModel> quizDataList = await ApiService.getWordQuiz();

      WordQuizProvider wordQuizModelProvider1 =
          Provider.of<WordQuizProvider>(context, listen: false);
      WordQuizProvider wordQuizModelProvider2 =
          Provider.of<WordQuizProvider>(context, listen: false);
      WordQuizProvider wordQuizModelProvider3 = Provider.of<WordQuizProvider>(
          context,
          listen: false); // 이거 이렇게 쓰면 안 되네.. 프로바이더가 어휘퀴즈 모델을 관리하도록 해야 함.

      wordQuizModelProvider1.setWordQuizModel(quizDataList[0]);
      wordQuizModelProvider2.setWordQuizModel(quizDataList[1]);
      wordQuizModelProvider3.setWordQuizModel(quizDataList[2]);

      List<Widget> quizList = [];

      for (final data in quizDataList) {
        // data는 WordQuizModel 각각
        quizList.add(buildEachQuiz(data));
      }

      return quizList;
    } else {
      throw Exception('로그인이 필요합니다.');
    }
  } // 3개 퀴즈 다 가져오기

  Widget buildEachQuiz(WordQuizModel model) {
    // 퀴즈 만드는 함수: 퀴즈제목, 보기1, 보기2
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            model.quiz,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(1, 1),
                      blurRadius: 1)
                ]),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: myColor.shade800,
                elevation: 5,
                minimumSize: const Size(120, 40),
                maximumSize: const Size(150, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                model.choices[0],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ), // 왼쪽 보기
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: myColor.shade800,
                elevation: 5,
                minimumSize: const Size(120, 40),
                maximumSize: const Size(150, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                model.choices[1],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ), // 오른쪽 보기
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              // 앱명 + 000님은 000일째 성장 중!
              children: [
                const Text(
                  '봐글봐글',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  '$nickname님은 봐글봐글과 함께\n$days일째 성장 중!',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Container(
              // 가로줄
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              height: 2,
              color: myColor.shade700,
            ),
            Container(
              // 어휘 퀴즈
              height: 140,
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: myColor.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: myColor.shade800,
                      blurRadius: 5,
                      offset: const Offset(5, 5),
                    )
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder<List<Widget>>(
                  future: buildWordQuiz(context),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Widget>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting for the data
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ); // Show an error message if an error occurs
                    } else {
                      // 데이터 전송 성공
                      List<Widget> quizList = snapshot.data!;
                      return PageView(
                        controller: _quizController,
                        children: quizList,
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SmoothPageIndicator(
              controller: _quizController,
              count: 3,
              effect: JumpingDotEffect(
                activeDotColor: myColor.shade100,
                dotColor: myColor.shade800,
                dotHeight: 12,
                dotWidth: 12,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "인문 카테고리",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            buildArticleList(humArticleList), //인문 카테고리 글 모음
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "사회 카테고리",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            buildArticleList(socArticleList),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                "과학·기술 카테고리",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            buildArticleList(sciArticleList),
          ],
        ),
      ),
    );
  }
}
