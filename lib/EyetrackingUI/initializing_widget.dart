import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

// InitializingWidget 위젯의 구현입니다. 이 위젯은 GazeTracker 초기화를 위한 UI를 제공합니다.
// InitializingWidget은 GazeTracker를 초기화하기 위한 UI를 제공합니다.
// 사용자는 "Initialize GazeTracker" 버튼을 클릭하여 GazeTracker를 초기화할 수 있으며, 사용자 옵션을 변경할 수 있는 스위치도 제공됩니다.
class InitializingWidget extends StatelessWidget {
  const InitializingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Column(
      children: <Widget>[
        const Text('You need to init GazeTracker first',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          height: 10,
        ),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              // 버튼을 클릭하면 consumer.initGazeTracker()를 호출하여 GazeTracker를 초기화합니다.
              onPressed: () {
                consumer.initGazeTracker();
              },
              child: const Text(
                'Initialize   GazeTracker',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.white24,
        ),
        // Container(
        //   width: double.maxFinite,
        //   color: Colors.white12,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       const Text(
        //         'With User Option',
        //         style: TextStyle(
        //             fontSize: 12,
        //             color: Colors.white,
        //             fontWeight: FontWeight.w600,
        //             decoration: TextDecoration.none),
        //       ),
        //       //upertinoSwitch: Cupertino 스타일의 스위치 위젯입니다.
        //       // consumer.isUserOption 값을 보여주고, 사용자가 스위치를 변경할 때
        //       // consumer.changeUserStatusOption(value)를 호출하여 사용자 옵션을 변경합니다.
        //       CupertinoSwitch(
        //           activeColor: Colors.white,
        //           value: consumer.isUserOption,
        //           onChanged: ((value) =>
        //               consumer.changeUserStatusOption(value))),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
