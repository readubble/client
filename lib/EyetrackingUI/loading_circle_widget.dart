import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// 이 위젯은 initializing 때, 로딩 중임을 나타내기 위해 회전하는 원형 스피너를 표시합니다.
// LoadingCircleWidget은 로딩 중인 상태를 나타내기 위해 회전하는 원형 스피너를 표시합니다. 이는 사용자에게 애플리케이션이 작업을 처리하고 있음을 시각적으로 알려줍니다.
class LoadingCircleWidget extends StatelessWidget {
  const LoadingCircleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      // SpinKitFadingCircle: Flutter Spinkit 패키지에서 제공하는 회전하는 원형 스피너 위젯입니다.
      child: SpinKitFadingCircle(
        color: Colors.white60,
        size: 120.0,
      ),
    );
  }
}
