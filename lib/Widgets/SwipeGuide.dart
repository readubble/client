import 'package:flutter/material.dart';
import 'dart:async';

class SwipeGuide extends StatefulWidget {
  final String text;
  const SwipeGuide({required this.text});

  @override
  State<SwipeGuide> createState() => _SwipeGuideState();
}

class _SwipeGuideState extends State<SwipeGuide> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: _isVisible ? 1.0 : 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          widget.text,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
