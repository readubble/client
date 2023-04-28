import 'package:flutter/material.dart';

class ReadingArticleScreen extends StatefulWidget {
  const ReadingArticleScreen({Key? key}) : super(key: key);

  @override
  State<ReadingArticleScreen> createState() => _ReadingArticleScreenState();
}

class _ReadingArticleScreenState extends State<ReadingArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // -> 방향 스와이프 시 이전 페이지로 돌아감
        if (details.delta.direction <= 0) {
          Navigator.pop(context);
        }
      },
      child: SafeArea(
        child: Scaffold(body: Center(child: Text("브람스가 어쩌구"))),
      ),
    );
  }
}
