import 'package:bwageul/Screens/LoginScreen.dart';
import 'package:bwageul/Screens/ReadingArticleScreen.dart';
import 'package:bwageul/Screens/ReadingThumbnailScreen.dart';
import 'package:bwageul/Screens/RegisterScreen.dart';
import 'package:bwageul/Screens/MainScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/startReading': (context) => const ReadingThumbnailScreen(),
        '/article': (context) => const ReadingArticleScreen(),
      },
    );
  }
}

MaterialColor myColor = const MaterialColor(0xff84B7D9, {
  //메인은 하늘색
  50: Color(0xffccecfd), //옅은 하늘색
  100: Color(0xff84B7D9), //메인 색상
  200: Color(0xffb8e1e3), //짙은 민트
  300: Color(0xffff8361), //짙은 산호색
  400: Color(0xffffae8c), //옅은 산호색
  500: Color(0xff0a4671), //네이비
  600: Color(0xfffce2ed), //연핑크
  700: Color(0xffE3E2E8), //옅은 회색
  800: Color(0xffb1b1b3), //짙은 회색
});
