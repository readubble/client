import 'dart:io';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circular_usage_indicator/circular_usage_indicator.dart';
import 'package:bwageul/Services/api_services.dart';
import 'package:provider/provider.dart';
import '../Providers/user_info_provider.dart';

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
      });
    }
  }

  Future<void> readArticleCount() async {
    countByDifficulty = await ApiService.getSolvedProblemCount();
    if (mounted) {
      setState(() {});
    }
  } // 읽은 글 개수

  Future<void> getCorrectWordCount() async {
    correctCount = await ApiService.getWordQuizResult();
    if (mounted) {
      setState(() {});
    }
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
    final myWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '마이페이지',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    icon: const Icon(Icons.settings),
                    iconSize: 30,
                  ),
                ],
              ),
              SizedBox(
                width: myWidth,
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          style: TextStyle(fontFamily: 'Godo'),
                          children: [
                            TextSpan(
                                text: userInfoProvider.user != null
                                    ? userInfoProvider.user!.nickname
                                    : '000',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                )),
                            const TextSpan(
                                text: '\n봐글봐글과 ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    height: 2)),
                            TextSpan(
                              text: userInfoProvider.user != null
                                  ? "${userInfoProvider.getDaysFromSignUp()}일"
                                  : '0일',
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 2),
                            ),
                            const TextSpan(
                                text: '째 성장 중',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    height: 2)),
                          ]),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: myWidth * 0.3,
                          width: myWidth * 0.3,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: myColor.shade800,
                                  offset: const Offset(3, 3),
                                  blurRadius: 3)
                            ],
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: userInfoProvider.user?.profile.length != 0
                                ? DecorationImage(
                                    image: NetworkImage(
                                        userInfoProvider.getProfileUrl()!),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          child: userInfoProvider.user?.profile.length == 0
                              ? Icon(Icons.person,
                                  size: 48, color: Colors.grey[400])
                              : null,
                        ),
                        TextButton(
                          onPressed: _getImageFromGallery,
                          child: Text(
                            '사진 변경',
                            style: TextStyle(color: myColor.shade800),
                          ),
                        )
                      ],
                    ), // 프로필 사진 컨테이너 + 사진 변경 버튼
                  ],
                ), // 00님은 봐글봐글과 함께한 지 00일
              ),
              Divider(
                height: 10,
                thickness: 1.5,
                color: myColor.shade700,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                '읽은 글 개수',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFdae9f4), //통계 - 상
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${countByDifficulty.length > 0 ? countByDifficulty[2]['level'] : " "}\n',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '${countByDifficulty.length > 0 ? countByDifficulty[2]['num'] : " "}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xffbcd8ea),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${countByDifficulty.length > 0 ? countByDifficulty[1]['level'] : " "}\n',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '${countByDifficulty.length > 0 ? countByDifficulty[1]['num'] : ''}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF77a6c3), //통계 - 하
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${countByDifficulty.length > 0 ? countByDifficulty[0]['level'] : " "}\n',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  '${countByDifficulty.length > 0 ? countByDifficulty[0]['num'] : ''}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                height: 10,
                thickness: 1.5,
                color: myColor.shade700,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
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
                    progressValue:
                        (correctCount / 3), // progress value from 0.0 to 1.0
                    progressColor: myColor.shade50,
                    size: 150,
                    children: [
                      const Text(
                        '맞힌 개수',
                        style: TextStyle(
                            color: Colors.black, fontSize: 20.0, height: 1.5),
                      ),
                      Text(
                        '$correctCount / 3',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }
}
