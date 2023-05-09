import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';
import 'HomeScreen.dart';
import 'LikesScreen.dart';
import 'MyPageScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final bool _isLoggedIn = true; // 로그인 여부를 저장하는 변수. 일단은 로그인되어있다고 가정!!!!!
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
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 35,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 35,
              ),
              label: 'Likes',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 35,
              ),
              label: 'MyPage',
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
