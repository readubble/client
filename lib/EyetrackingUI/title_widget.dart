import 'package:flutter/material.dart';

//이 위젯은 화면 상단에 제목과 설명을 표시하는 역할을 합니다.
//TitleWidget은 화면 상단에 "SeeSo Sample"라는 제목과 설명을 표시합니다.
// 제목은 흰색 텍스트로, 크기 24의 폰트로 스타일링되어 있습니다.
// 설명은 흰색 텍스트로, 크기 16의 폰트로 스타일링되어 있습니다.
// 제목과 설명 사이에는 회색 계통의 구분선이 표시됩니다.
// 이 위젯은 사용자에게 "Gaze Tracking" 경험을 시작하기 위해 아래의 단계를 따르도록 안내합니다.
class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '시선 추적 기능',
                style: TextStyle(decoration: TextDecoration.none, fontSize: 24),
              ),
              Divider(
                // Divider: 수평 구분선을 나타내는 위젯입니다. 회색 계통의 색상을 사용합니다.
                color: Colors.grey[800],
              ),
            ]));
  }
}
