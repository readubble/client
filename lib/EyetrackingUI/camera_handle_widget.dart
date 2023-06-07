import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

// 이 위젯은 카메라 권한을 요청하는 UI를 제공합니다.
class CameraHandleWidget extends StatelessWidget {
  const CameraHandleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          '카메라 허가를 받아야 합니다!',
          style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              decoration: TextDecoration.none),
        ),
        Container(
          width: double
              .maxFinite, //width를 double.maxFinite로 설정하여 가로 방향으로 최대한 확장될 수 있도록 합니다.
          color: Colors.white12,
          child: TextButton(
              // TextButton: 카메라 권한을 요청하는 버튼을 생성하는 위젯입니다.
              // 클릭 이벤트가 발생하면 Provider.of<GazeTrackerProvider>(context, listen: false).handleCamera()를 호출하여
              // GazeTrackerProvider의 handleCamera() 메서드를 실행합니다.
              // 버튼의 텍스트는 "Click here to request camera authorization"로 설정되며, 글자 색상은 Colors.white로 지정됩니다.
              onPressed: () {
                Provider.of<GazeTrackerProvider>(context, listen: false)
                    .handleCamera();
              },
              child: const Text(
                '카메라 승인 요청',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
