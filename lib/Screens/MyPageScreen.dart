import 'dart:io';
import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circular_usage_indicator/circular_usage_indicator.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String nickname = '홍길동';
  File? _image; // 프로필 사진

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                // 로그인된 상태
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '마이페이지',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                    iconSize: 30,
                  ), // 설정
                ],
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
                    height: 200,
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
                            text: '$nickname',
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                        TextSpan(
                          text: '100일',
                          style: TextStyle(
                              fontSize: 20,
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
                            image: _image != null
                                ? DecorationImage(
                                    image: FileImage(_image!),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          child: _image == null
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
                          center: Alignment.topCenter,
                          radius: 1,
                          colors: [
                            Colors.white,
                            myColor.shade400,
                          ],
                          stops: [0.0, 0.9],
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '상\n',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: '30',
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
                          center: Alignment.topCenter,
                          radius: 1,
                          colors: [
                            Colors.white,
                            myColor.shade200,
                          ],
                          stops: [0.0, 0.9],
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '중\n',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: '3',
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
                          center: Alignment.topCenter,
                          radius: 1,
                          colors: [
                            Colors.white,
                            myColor.shade100,
                          ],
                          stops: [0.0, 0.9],
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '하\n',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: '2',
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
                '오늘의 문해력 퀴즈',
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
                    backgroundColor: myColor.shade600,
                    borderColor: Colors.transparent,
                    progressValue: 0.66, // progress value from 0.0 to 1.0

                    progressColor: myColor.shade50,
                    size: 150,
                    children: [
                      Text(
                        '맞춘 개수',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        '2 / 3',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
