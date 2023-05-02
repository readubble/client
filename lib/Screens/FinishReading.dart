import 'package:flutter/material.dart';

import '../main.dart';

class FinishReading extends StatelessWidget {
  const FinishReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Text(
                        "브람스 교향곡 4번",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "난이도 ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "중",
                            style: TextStyle(
                                fontSize: 16,
                                color: myColor.shade300,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
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
                        "reading result",
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
