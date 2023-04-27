import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({Key? key}) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // appBar 높이 조절
            child: AppBar(
              bottom: TabBar(controller: _tabController, tabs: const <Widget>[
                Tab(
                  child: Text('저장한 글', style: TextStyle(fontSize: 20)),
                ),
                Tab(
                  child: Text('저장한 단어', style: TextStyle(fontSize: 20)),
                ),
              ]),
            ),
          ),
          body: TabBarView(controller: _tabController, children: const <Widget>[
            Center(
              child: Text(
                "글글",
                style: TextStyle(fontSize: 40),
              ),
            ),
            Center(
              child: Text("단어단어", style: TextStyle(fontSize: 40)),
            ),
          ]),
        ),
      ),
    );
  }
}
