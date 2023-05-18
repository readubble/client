import 'package:bwageul/Models/user_info_provider.dart';
import 'package:bwageul/Models/word_quiz_provider.dart';
import 'package:bwageul/Screens/dictionary.dart';
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
import 'package:page_transition/page_transition.dart';

import 'Models/profile_image_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ChangeNotifierProvider(create: (_) => ProfileImageProvider()),
      ChangeNotifierProvider(create: (_) => WordQuizProvider())
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
      theme: ThemeData(primarySwatch: myColor),
      debugShowCheckedModeBanner: false, //오른쪽 상단 DEBUG 배너 비활성화
      initialRoute: '/',
      routes: {
        // '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/startReading': (context) => const ReadingThumbnailScreen(),
        '/article': (context) => const ReadingArticleScreen(),
        '/finish': (context) => const FinishReading(),
        '/dictionary': (context) => const KoreanDictionary(),
        '/settings': (context) => const Settings(),
      },
      home: AnimatedSplashScreen(
        duration: 3000,
        splashIconSize: 700.0,
        splash: SizedBox(
          child: Image.asset(
              'assets/images/go.jpeg',
            // fit: BoxFit.scaleDown,
            // fit: BoxFit.fill,
            // fit: BoxFit.fill,
            fit: BoxFit.cover,
          ),
        ),
        nextScreen: MainScreen(),
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
  200: Color(0xFF00CC66), //짙은 민트
  300: Color(0xffff8361), //짙은 산호색
  400: Color(0xFFFF8C00), //옅은 산호색
  // 400: Color(0xFFFFC0CB), //옅은 산호색
  500: Color(0xff0a4671), //네이비 - 과학
  600: Color(0xFFFCFFF9), //연두
  700: Color(0xfff1f1f1), //옅은 회색
  800: Color(0xffa2a2a2), //짙은 회색
  // //인문
  // 810: Color(0xFF4B0082), //진한 보라색
  // 812: Color(0xFFFFC0CB), //연한 핑크색
});
