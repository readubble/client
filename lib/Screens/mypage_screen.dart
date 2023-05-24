import 'dart:io';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circular_usage_indicator/circular_usage_indicator.dart';
import 'package:bwageul/Services/api_services.dart';
import 'package:provider/provider.dart';
import '../Models/profile_image_provider.dart';
import '../Models/user_info_provider.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int correctCount = 0;
  List<dynamic> countByDifficulty = [];
  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final serverImageUrl = await ApiService.changeProfileImage(pickedFile);
      setState(() {
        final provider = Provider.of<UserInfoProvider>(context, listen: false);
        provider.setProfileUrl(serverImageUrl);
        print('now imageUrl:${provider.getProfileUrl()}');
      });
    }
  }

  Future<void> readArticleCount() async {
    countByDifficulty = await ApiService.getSolvedProblemCount();
    setState(() {});
  } // 읽은 글 개수

  Future<void> getCorrectWordCount() async {
    correctCount = await ApiService.getWordQuizResult();
    setState(() {});
  } // 어휘 퀴즈 개수

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCorrectWordCount();
    readArticleCount();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '마이페이지',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 130),
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width,
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: myColor.shade700,
                          boxShadow: [
                            BoxShadow(
                                color: myColor.shade800,
                                offset: Offset(3, 3),
                                blurRadius: 3)
                          ],
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: userInfoProvider.user != null
                                    ? userInfoProvider.user!.nickname
                                    : '000',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    shadows: [
                                      Shadow(
                                          color: myColor.shade800,
                                          blurRadius: 3,
                                          offset: Offset(1, 1))
                                    ])),
                            TextSpan(
                                text: '님은 봐글봐글과 함께한 지\n',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                            TextSpan(
                              text: userInfoProvider.user != null
                                  ? userInfoProvider
                                          .getDaysFromSignUp()
                                          .toString() +
                                      "일"
                                  : '0일',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                        color: myColor.shade800,
                                        blurRadius: 3,
                                        offset: Offset(1, 1))
                                  ]),
                            ),
                          ]),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: myColor.shade800,
                                      offset: Offset(3, 3),
                                      blurRadius: 3)
                                ],
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: userInfoProvider.user?.profile != ""
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            userInfoProvider.getProfileUrl()!),
                                        fit: BoxFit.cover)
                                    : null,
                              ), // 프로필 사진 컨테이너
                              child: userInfoProvider.user?.profile.length == 0
                                  ? Icon(Icons.person,
                                      size: 48, color: Colors.grey[400])
                                  : null,
                            ),
                            TextButton(
                                onPressed: _getImageFromGallery,
                                child: Text(
                                  '프로필 사진 변경',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: myColor.shade800,
                                      fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '읽은 글 개수',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 1,
                              colors: [
                                Colors.white,
                                Color(0xffF5CEC7), //통계 - 상
                              ],
                              stops: [0, 0], // 그라데이션 빼려면 0.0 0.0 하면 됨
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${countByDifficulty.length > 0 ? countByDifficulty[2]['level'] : " "}\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '${countByDifficulty.length > 0 ? countByDifficulty[2]['num'] : " "}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                      Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 1,
                              colors: [
                                Colors.white,
                                Color(0xFFE5F4D5), //통계 - 중
                              ],
                              stops: [0, 0], // 그라데이션 빼려면 0.0 0.0 하면 됨
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${countByDifficulty.length > 0 ? countByDifficulty[1]['level'] : " "}\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '${countByDifficulty.length > 0 ? countByDifficulty[1]['num'] : ''}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                      Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 1,
                              colors: [
                                Colors.white,
                                Color(0xFFE7E0EC), //통계 - 하
                              ],
                              stops: [0, 0], // 그라데이션 빼려면 0.0 0.0 하면 됨
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${countByDifficulty.length > 0 ? countByDifficulty[0]['level'] : " "}\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      '${countByDifficulty.length > 0 ? countByDifficulty[0]['num'] : ''}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '오늘의 어휘 퀴즈',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularUsageIndicator(
                        elevation: 20.0,
                        backgroundColor: myColor.shade700,
                        borderColor: Colors.transparent,
                        progressValue: (correctCount /
                            3), // progress value from 0.0 to 1.0
                        progressColor: myColor.shade50,
                        size: 150,
                        children: [
                          Text(
                            '맞힌 개수',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                height: 1.5),
                          ),
                          Text(
                            '$correctCount / 3',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
          Positioned(
            top: 25,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              icon: const Icon(Icons.settings),
              iconSize: 35,
            ),
          )
        ],
      ),
    );
  }
}
