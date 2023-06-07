import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

// 이 위젯은 눈동자 추적 위치에 원형으로 표시되는 UI를 제공합니다.
//GazePointWidget은 Provider.of<GazeTrackerProvider>(context)를 사용하여 GazeTrackerProvider의 인스턴스를 가져온 후,
// 해당 인스턴스의 pointX와 pointY 값을 사용하여 원형을 눈동자 추적 위치에 정확히 배치합니다.
// 원형의 크기와 색상은 미리 정의된 값으로 설정되어 있습니다.
class GazePointWidget extends StatelessWidget {
  static const circleSize =
      30.0; // circleSize: 원형의 크기를 지정하는 상수입니다. 값은 20.0으로 설정되어 있습니다.

  const GazePointWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final consumer: Provider.of<GazeTrackerProvider>(context)를 사용하여 GazeTrackerProvider의 인스턴스를 가져옵니다.
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Positioned(
        //Positioned: 자식 위젯을 특정 위치에 배치하는 위젯입니다.
        // left와 top 속성을 사용하여 위치를 설정합니다. left 값은 consumer.pointX - circleSize / 2.0로 설정되며,
        // top 값은 consumer.pointY - circleSize / 2.0로 설정됩니다.
        // 따라서 원형이 눈동자 추적 위치의 중심에 정확히 배치됩니다.
        left: consumer.pointX - circleSize / 2.0,
        top: consumer.pointY - circleSize / 2.0,
        //Container: 원형을 그리기 위한 컨테이너입니다. width와 height를 circleSize로 설정하여 원형의 크기를 지정합니다.
        // decoration 속성은 BoxDecoration으로 설정되어 있으며, 배경색은 Colors.red로 지정되고, 모양은 BoxShape.circle로 지정됩니다.
        child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.4), shape: BoxShape.circle)));
  }
}
