import 'package:flutter/material.dart';
import '../main.dart';

class BottomSummarySheet extends StatefulWidget {
  const BottomSummarySheet({Key? key}) : super(key: key);

  @override
  State<BottomSummarySheet> createState() => _BottomSummarySheetState();
}

class _BottomSummarySheetState extends State<BottomSummarySheet> {
  final PageController pageController = PageController(
    initialPage: 0,
  );
  List<int> chosenAnswer = [0, 0, 0]; //총 3문제
  String choice1 = "바로 다음의 해";
  String choice2 = "올해";
  String choice3 = "지난해";

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: myColor.shade600, // 배경 색상
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                    spreadRadius: 10)
              ] // 둥근 모서리
              ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  //가로줄
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: myColor.shade800,
                      borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "내용 정리하기",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "[문제 1]",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "‘이듬해’와 같은 뜻의 단어를 고르세요.",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    RadioListTile(
                        title: Text(
                          choice1,
                          style: TextStyle(fontSize: 16),
                        ),
                        value: 1,
                        groupValue: chosenAnswer[0],
                        onChanged: (value) {
                          setState(() {
                            chosenAnswer[0] = value!;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          choice2,
                          style: TextStyle(fontSize: 16),
                        ),
                        value: 2,
                        groupValue: chosenAnswer[0],
                        onChanged: (value) {
                          setState(() {
                            chosenAnswer[0] = value!;
                          });
                        }),
                    RadioListTile(
                        title: Text(
                          choice3,
                          style: TextStyle(fontSize: 16),
                        ),
                        value: 3,
                        groupValue: chosenAnswer[0],
                        onChanged: (value) {
                          setState(() {
                            chosenAnswer[0] = value!;
                          });
                        }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "다음",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
