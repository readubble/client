import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

//이 위젯은 GazeTracker를 비활성화하고 재시작을 유도하는 UI를 제공합니다.
//즉, initializing 후에 Stop GazeTracker가 뜨는 위젯
class DeinitModeWidget extends StatelessWidget {
  const DeinitModeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: <Widget>[
      const Text('GazeTracker is activated.',
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
        // TextButton: GazeTracker를 중지하는 버튼을 생성하는 위젯입니다.
        child: TextButton(
            onPressed: () {
              Provider.of<GazeTrackerProvider>(context, listen: false)
                  .deinitGazeTracker();
            },
            child: const Text(
              'Stop GazeTracker',
              style: TextStyle(color: Colors.white),
            )),
      ),
      Container(
        width: double.maxFinite,
        height: 1,
        color: Colors.white24,
      ),
      const Text(
          'You can init GazeTracker With UserOption! \n (need to restart GazeTracker)',
          style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              decoration: TextDecoration.none)),
    ]);
  }
}
