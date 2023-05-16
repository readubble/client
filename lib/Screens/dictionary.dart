import 'package:flutter/material.dart';

import '../main.dart';

class KoreanDictionary extends StatefulWidget {
  const KoreanDictionary({Key? key}) : super(key: key);

  @override
  State<KoreanDictionary> createState() => _KoreanDictionaryState();
}

class _KoreanDictionaryState extends State<KoreanDictionary> {
  TextEditingController _searchController = TextEditingController();
  List<bool> likes = [false]; // 단어장 추가 T/F

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
                            "표준국어대사전",
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
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        height: 55,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: '검색어를 입력하세요',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.search_rounded,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {});
                              },
                            ), //돋보기 버튼
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${_searchController.text}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: myColor.shade500,
                                shadows: [
                                  Shadow(
                                      color: myColor.shade800,
                                      blurRadius: 2,
                                      offset: Offset(1, 1))
                                ]),
                          ),
                          Text(
                            " 검색 결과",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: myColor.shade700,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: myColor.shade800,
                                  blurRadius: 3,
                                  offset: Offset(3, 3))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: '의사',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: const Offset(0.0, -7.0),
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ])),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      likes[0] = !likes[0];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      shadowColor: myColor.shade800,
                                      elevation: 0),
                                  child: Row(
                                    children: [
                                      likes[0]
                                          ? Icon(
                                              Icons.favorite,
                                              size: 25,
                                              color: myColor.shade100,
                                            )
                                          : Icon(
                                              Icons.favorite_outline_rounded,
                                              size: 25,
                                              color: myColor.shade100,
                                            ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '명사',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: myColor.shade500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '옷을 넣어 두는 상자.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ), // 단어 뜻 한개
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}
