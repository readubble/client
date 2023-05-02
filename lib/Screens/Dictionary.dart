import 'package:flutter/material.dart';

import '../main.dart';

class KoreanDictionary extends StatefulWidget {
  const KoreanDictionary({Key? key}) : super(key: key);

  @override
  State<KoreanDictionary> createState() => _KoreanDictionaryState();
}

class _KoreanDictionaryState extends State<KoreanDictionary> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      size: 35,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "국립국어원",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "국어사전",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        // 가로줄
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        height: 2,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "searching result",
                        style: TextStyle(fontSize: 18, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ), // 하단 퀴즈, 글 요약하는 창
      ])),
    );
  }
}
