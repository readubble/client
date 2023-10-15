import 'package:bwageul/Providers/problem_id_provider.dart';
import 'package:bwageul/Providers/user_info_provider.dart';
import 'package:bwageul/Screens/dictionary.dart';
import 'package:bwageul/Screens/eyetracking_setting.dart';
import 'package:bwageul/Screens/finish_reading.dart';
import 'package:bwageul/Screens/login_screen.dart';
import 'package:bwageul/Screens/reading_article_screen.dart';
import 'package:bwageul/Screens/reading_thumbnail_screen.dart';
import 'package:bwageul/Screens/register_screen.dart';
import 'package:bwageul/Screens/main_screen.dart';
import 'package:bwageul/Screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'Providers/gaze_tracker_provider.dart';
import 'Providers/problem_info_provider.dart';
import 'Providers/profile_image_provider.dart';
import 'Providers/quiz_list_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
      ChangeNotifierProvider(create: (_) => ProblemInfoProvider()),
      ChangeNotifierProvider(create: (_) => QuizListProvider()),
      ChangeNotifierProvider(create: (_) => ProblemIdProvider()),
      ChangeNotifierProvider(create: (_) => GazeTrackerProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readubble',
      theme: ThemeData(primarySwatch: myColor, fontFamily: 'lottedream'),
      debugShowCheckedModeBanner: false,
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/startReading': (context) => const ReadingThumbnailScreen(),
        '/article': (context) => const ReadingArticleScreen(),
        '/finish': (context) => const FinishReading(),
        '/dictionary': (context) => const KoreanDictionary(),
        '/settings': (context) => const Settings(),
        '/eyetracking': (context) => const Eyetracking(),
      },
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset(
          'assets/images/loading4.jpg',
          fit: BoxFit.contain,
        ),
        splashIconSize: double.infinity,
        centered: true,
        nextScreen: Builder(
          builder: (context) {
            Future.delayed(Duration.zero, () {
              Navigator.pushNamed(context, '/main');
            });
            return CircularProgressIndicator(); // Return an empty container while navigating to '/main'
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: myColor.shade100,
      ),
    );
  }
}

MaterialColor myColor = const MaterialColor(0xff84B7D9, {
  //메인은 하늘색
  50: Color(0xffccecfd), //옅은 하늘색
  100: Color(0xff84B7D9), //메인 색상
  200: Color(0xffBAEDCE), //짙은 민트 - 사회
  300: Color(0xffff8361), //짙은 산호색 - 난이도 상, 중, 하
  400: Color(0xFFF3D5CF), //옅은 산호색 - 인문
  500: Color(0xff00008B), //네이비 - 버튼 칼라
  600: Color(0xffE7DDEA), //연두 - 과학
  700: Color(0xfff1f1f1), //옅은 회색 - 마이페이지 프로필 블록, 맞춘 개수 물채우기 뒷배경
  800: Color(0xffa2a2a2), //짙은 회색 - 하단 바
  801: Color(0xFFE7DDEA), //통계 - 상
  802: Color(0xFFF6E8D0), //통계 - 중
  803: Color(0xFFDBEFE4), //통계 - 하
  // //인문
});
