import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

// 이 위젯은 눈동자 추적기의 캘리브레이션 작업을 나타내는 UI를 제공합니다.
// CalibrationWidget은 Provider.of<GazeTrackerProvider>(context)를 사용하여
// GazeTrackerProvider의 인스턴스를 가져와서 consumer 변수에 할당합니다.
// 그런 다음 consumer를 사용하여 현재 캘리브레이션 상태와 진행률을 나타내는 UI를 구성합니다.
// 이를 통해 사용자에게 눈동자 추적기의 캘리브레이션 작업을 시각적으로 보여줍니다.
class CalibrationWidget extends StatelessWidget {
  const CalibrationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // build() 메서드: 위젯을 렌더링하는 메서드입니다. BuildContext와 Provider를 통해 GazeTrackerProvider의 인스턴스에 액세스합니다.
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Container(
        color: const Color.fromARGB(140, 0, 0, 0),
        // Stack: 다른 위젯을 겹쳐서 배치할 수 있는 위젯입니다. 자식 위젯들을 StackFit.expand로 설정하여 전체 영역을 차지하도록 합니다.
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text('원을 보세요!',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.none)),
                SizedBox(
                  height: 80,
                ),
              ],
            )),
            // Positioned: 자식 위젯을 위치시키기 위한 위젯입니다.
            // consumer.caliX와 consumer.caliY 값을 사용하여 위치를 설정합니다.
            // 이 값들은 GazeTrackerProvider에서 제공되는 눈동자의 위치 정보입니다.
            Positioned(
              left: consumer.caliX - 24,
              top: consumer.caliY - 24,
              // CircularPercentIndicator: 원형의 퍼센트 인디케이터를 생성하는 위젯입니다.
              // radius로 반지름 크기를 설정하고, lineWidth로 퍼센트 인디케이터의 두께를 설정합니다.
              // animation을 비활성화하고, percent에 consumer.progress 값을 설정하여 퍼센트를 지정합니다.
              // center에는 현재 퍼센트 값을 표시하는 텍스트를 설정합니다.
              child: CircularPercentIndicator(
                  radius: 24,
                  lineWidth: 2,
                  animation: false,
                  percent: consumer.progress,
                  center: Text('${(consumer.progress * 100).round()}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0))),
            ),
          ],
        ));
  }
}
