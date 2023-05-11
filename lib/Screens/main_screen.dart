import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';
import 'home_screen.dart';
import 'likes_screen.dart';
import 'mypage_screen.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final bool _isLoggedIn = false; // 로그인 여부를 저장하는 변수. 일단은 로그인되어있다고 가정!!!!!
  bool hasNotch = IphoneHasNotch.hasNotch;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const LikesScreen(),
    const MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2 && !_isLoggedIn) {
        // My Page가 선택되었는데 로그인이 안 되어 있으면
        Navigator.pushNamed(context, '/login'); // 로그인 페이지로 이동
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 35,
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 35,
              ),
              label: '북마크',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 35,
              ),
              label: '마이페이지',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: myColor.shade100,
          unselectedItemColor: myColor.shade800,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}