import 'package:bwageul/Services/api_services.dart';
import 'package:flutter/material.dart';

import '../Models/word_info_model.dart';
import '../main.dart';

class KoreanDictionary extends StatefulWidget {
  const KoreanDictionary({Key? key}) : super(key: key);

  @override
  State<KoreanDictionary> createState() => _KoreanDictionaryState();
}

class _KoreanDictionaryState extends State<KoreanDictionary> {
  final TextEditingController _searchController = TextEditingController();
  List<bool> likes = []; // 단어장 추가 T/F
  List<WordInfoModel> searchResults = []; // 검색 결과 리스트

  Future<void> searchDictionary() async {
    FocusScope.of(context).unfocus();
    try {
      final result =
          await ApiService.getDictionarySearch(_searchController.text);

      setState(() {
        searchResults = result;
        print("searchResults: $searchResults"); // result 출력
        likes =
            searchResults.map((e) => (e.saveFl == "Y") ? true : false).toList();
        for (int i = 0; i < searchResults.length; i++) {
          print('${searchResults[i].wordNm}  ${searchResults[i].wordMean}');
        }
      });
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  List<Widget> showWordList() {
    List<Widget> buttonList = [];

    for (int i = 0; i < searchResults.length; i++) {
      Container wordInfo = Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: myColor.shade700,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: myColor.shade800,
              blurRadius: 3,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${searchResults[i].wordNm}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      likes[i] = !likes[i];
                    });
                    print(likes[i]);
                    await ApiService.updateWordBookmark(
                      searchResults[i].targetCode,
                      searchResults[i].wordNm,
                      searchResults[i].wordMean,
                    );
                  },
                  icon: likes[i]
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
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    searchResults[i].wordMean, // 결과에서 뜻 가져오기
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      buttonList.add(wordInfo);
    }
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: Column(children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
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
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            // 가로줄
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            height: 2,
                            color: Colors.black,
                          ),
                          const SizedBox(
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                                  icon: const Icon(
                                    Icons.search_rounded,
                                    size: 30,
                                  ),
                                  onPressed: searchDictionary,
                                ), //돋보기 버튼
                              ],
                            ),
                          ),
                          const SizedBox(
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
                              const Text(
                                " 검색 결과",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ...showWordList(),
                        ],
                      ),
                    ),
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
