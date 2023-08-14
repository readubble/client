import 'dart:ui';
import 'package:bwageul/Services/api_services.dart';
import 'package:bwageul/Services/storage.dart';
import 'package:bwageul/Widgets/unlocked_article_tile.dart';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Models/article_info_model.dart';
import '../Providers/user_info_provider.dart';
import '../Models/word_quiz_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _quizController = PageController(initialPage: 0);
  bool hasUserData = false;
  List<ArticleInfoModel> humArticleList = [];
  List<ArticleInfoModel> socArticleList = [];
  List<ArticleInfoModel> sciArticleList = [];
  List<bool> isQuizEnabled = [true, true, true];
  List<bool> isCorrect = [false, false, false];
  List<WordQuizModel> quizDataList = [];
  List<int> isClicked = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadArticleList();
    _loadWordQuiz();
  }

  Future<void> _loadUserInfo() async {
    // 로그인은 되어 있지만, 유저 정보가 로드되지 않은 상태(최초 1회)
    if (!hasUserData) {
      String? userId = await getUserId();
      if (userId != null) {
        var user = await ApiService.getUserInfoById(userId!);
        final userInfoProvider =
            Provider.of<UserInfoProvider>(context, listen: false);
        userInfoProvider.setUser(user);
        if (mounted)
          setState(() {
            hasUserData = true;
          });
      }
    }
  }

  Future<void> _loadArticleList() async {
    if (await isLoggedIn()) {
      List<ArticleInfoModel> list1 =
          await ApiService.getArticles(1); // 1: 인문, 2: 사회, 3: 과학
      List<ArticleInfoModel> list2 = await ApiService.getArticles(2);
      List<ArticleInfoModel> list3 = await ApiService.getArticles(3);
      if (mounted) {
        setState(() {
          humArticleList = list1;
          socArticleList = list2;
          sciArticleList = list3;
        });
      }
    }
  }

  Future<void> _loadWordQuiz() async {
    if (await isLoggedIn()) {
      List<WordQuizModel> list = await ApiService.getWordQuiz();
      if (mounted) {
        setState(() {
          quizDataList = list;
          isQuizEnabled =
              list.map((e) => (e.solved == "Y") ? false : true).toList();
          isCorrect = list
              .map((e) => (e.answer == e.solvedChoice) ? true : false)
              .toList();
          isClicked =
              list.map((e) => (e.solved == "Y") ? e.solvedChoice : 0).toList();
        });
      }
    }
  }

  List<Widget> buildWordQuiz() {
    List<Widget> quizList = [];
    for (int i = 0; i < quizDataList.length; i++) {
      quizList.add(
          buildEachQuiz(quizDataList[i], i)); // Enable 상태를 위한 인덱스 값도 매개변수로 넘겨줌.
    }
    return quizList;
  } // 어휘 퀴즈 3개(Widget)을 불러오기

  Widget buildEachQuiz(WordQuizModel model, int quizIdx) {
    return Stack(children: [
      Column(
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
                  height: 1.5,
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
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: (isClicked[quizIdx] == 1)
                      ? Colors.grey.shade400
                      : Colors.white,
                  disabledForegroundColor: Colors.black,
                  shadowColor: myColor.shade800,
                  elevation: 5,
                  minimumSize: const Size(120, 40),
                  maximumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isQuizEnabled[quizIdx]
                    ? () => submitQuizResult(model, 1, quizIdx)
                    : null, // isEnabled == false이면 onPressed disabled
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
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: (isClicked[quizIdx] == 2)
                      ? Colors.grey.shade400
                      : Colors.white,
                  disabledForegroundColor: Colors.black,
                  shadowColor: myColor.shade800,
                  elevation: 5,
                  minimumSize: const Size(120, 40),
                  maximumSize: const Size(150, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isQuizEnabled[quizIdx]
                    ? () => submitQuizResult(model, 2, quizIdx)
                    : null, // isEnabled == false이면 onPressed disabled
                child: Text(
                  model.choices[1],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ), // 오른쪽 보기
            ],
          ),
        ],
      ),
      if (!isQuizEnabled[
          quizIdx]) // disabled 된 상태 = 즉, 이미 푼 문제의 경우 아이콘으로 정답 여부를 보여줌.
        isCorrect[quizIdx]
            ? Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.circle_outlined,
                  size: 125,
                  color: Colors.green.withOpacity(0.7),
                ),
              )
            : Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.close,
                  size: 130,
                  color: Colors.red.withOpacity(0.7),
                ),
              )
    ]);
  } // 어휘 퀴즈 만드는 함수: 퀴즈제목, 보기1, 보기2

  void submitQuizResult(WordQuizModel model, int choice, int quizIdx) async {
    // 버튼 둘 중 하나가 클릭될 때마다
    setState(() {
      isQuizEnabled[quizIdx] =
          !isQuizEnabled[quizIdx]; // 하나라도 눌렸으면 풀 수 없는 문제로 설정.
      isClicked[quizIdx] = choice; // 지금 1번, 2번 버튼이 선택됨
    });
    String quizResult = '';
    if (choice == model.answer) {
      // 정답처리
      quizResult = 'Y';
      setState(() {
        isCorrect[quizIdx] = true;
      });
    } else {
      quizResult = 'N';
      setState(() {
        isCorrect[quizIdx] = false;
      });
    }
    await ApiService.postWordQuiz(model.quizId, choice, quizResult);
  } // 서버에 어휘 퀴즈 결과 전송

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              // 앱명 + 000님은 000일째 성장 중!
              children: [
                const Text(
                  '봐글봐글',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: userInfoProvider.user == null
                          ? CircularProgressIndicator()
                          : Text(
                              '${userInfoProvider.nickname}님은 봐글봐글과 함께\n${userInfoProvider.getDaysFromSignUp()}일째 성장 중!',
                              style: const TextStyle(fontSize: 15, height: 1.4),
                              textAlign: TextAlign.start,
                            )),
                )
              ],
            ),
            Divider(
              height: 20,
              thickness: 1.5,
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
                child: PageView(
                  controller: _quizController,
                  children: buildWordQuiz(),
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
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
