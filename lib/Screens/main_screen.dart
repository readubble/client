import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';
import 'package:provider/provider.dart';
import '../Providers/user_info_provider.dart';
import '../Services/api_services.dart';
import '../Services/storage.dart';
import 'home_screen.dart';
import 'likes_screen.dart';
import 'mypage_screen.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const LikesScreen(),
    const MyPageScreen(),
  ];

  Future<void> loadStartScreen() async {
    // 로그인 여부 확인하여 시작 스크린 설정
    String? userId = await getUserId();
    if (userId == null)
      Navigator.pushNamed(context, '/login'); // 로그인 안 되어 있으면 로그인 페이지로 이동
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadStartScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
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
    );
  }
}
