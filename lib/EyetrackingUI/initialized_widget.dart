import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/EyetrackingUI/deinit_mode_widget.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

// 이 위젯은 초기화된 상태에서 사용자의 시선 추적을 시작할 수 있는 UI를 제공합니다.
//InitializedWidget은 Provider.of<GazeTrackerProvider>(context)를 사용하여
// GazeTrackerProvider의 인스턴스를 가져온 후, 해당 인스턴스의 startTracking() 메서드를 호출하여 시선 추적을 시작할 수 있습니다.
// UI에는 "Start Tracking"이라는 버튼이 표시되며, 버튼을 클릭하면 startTracking() 메서드가 실행됩니다.
// 또한, DeinitModeWidget을 포함하여 GazeTracker를 중지하는 기능도 제공됩니다.
class InitializedWidget extends StatelessWidget {
  const InitializedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final consumer: Provider.of<GazeTrackerProvider>(context)를 사용하여 GazeTrackerProvider의 인스턴스를 가져옵니다
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Column(
      children: <Widget>[
        //DeinitModeWidget: DeinitModeWidget을 추가로 포함하는 위젯입니다. 이 위젯은 초기화된 상태에서 GazeTracker를 중지할 수 있는 UI를 제공합니다.
        const DeinitModeWidget(),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('Now You can track you gaze!',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              // TextButton: "Start Tracking"이라는 텍스트를 표시하는 버튼 위젯입니다.
              // 버튼을 클릭하면 consumer.startTracking()을 호출하여 시선 추적을 시작합니다.
              onPressed: () {
                consumer.startTracking();
              },
              child: const Text(
                'Start Tracking',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
