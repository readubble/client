import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Models/app_stage.dart';

import 'package:bwageul/Providers/gaze_tracker_provider.dart';
import 'package:bwageul/EyetrackingUI/user_status_widget.dart';
import 'deinit_mode_widget.dart';
import 'saved_dialog_widget.dart';

// 이 위젯은 추적 모드에서의 사용자 상태와 관련된 기능을 제공합니다.
// TrackingModeWidget은 추적 모드에서 다양한 동작을 수행할 수 있는 기능을 제공합니다.
// 사용자는 "Stop tracking" 버튼을 클릭하여 추적을 중지할 수 있으며,
// "Start Calibration" 버튼을 클릭하여 캘리브레이션을 시작할 수 있습니다.
// 캘리브레이션 유형은 CupertinoSegmentedControl를 통해 선택할 수 있으며, 캘리브레이션 데이터를 저장할 수도 있습니다.
// 사용자 상태에 따라 추가적인 위젯인 UserSatatusWidget이 표시됩니다.
class TrackingModeWidget extends StatelessWidget {
  const TrackingModeWidget({Key? key}) : super(key: key);

  // _showSavedDialog() 메서드: 저장된 대화상자를 표시하는 메서드입니다. SaveDataDialogWidget를 사용합니다.
  void _showSavedDialog(BuildContext context) {
    var state = Provider.of<GazeTrackerProvider>(context, listen: false);
    showCupertinoDialog(
        context: context,
        builder: (_) => ChangeNotifierProvider<GazeTrackerProvider>.value(
              value: state,
              child: const SaveDataDialogWidget(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return Column(
      children: <Widget>[
        const DeinitModeWidget(), // DeinitModeWidget: 비활성 모드 설정을 위한 위젯입니다.
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('추적 중입니다!!',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () {
                consumer.stopTracking();
              },
              child: const Text(
                'Stop tracking',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('또한 보정을 통해 정확도를 향상시킬 수 있습니다',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () {
                consumer.startCalibration();
              },
              child: Text(
                (consumer.state == GazeTrackerState.calibrating)
                    ? 'Calibration started!'
                    : 'Start Calibration',
                style: const TextStyle(color: Colors.white),
              )),
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.white24,
        ),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: const Text(
                  '"Five Points" Calibration',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none),
                ),
              ),
              const SizedBox(
                width: 60,
              ),
              // CupertinoSegmentedControl: 세그먼트 선택 컨트롤을 나타내는 위젯입니다.
              // 여러 개의 세그먼트 옵션 중 하나를 선택할 수 있습니다.
              // CupertinoSegmentedControl(
              //   children: const {
              //     5: Text(" FIVE_POINT ",
              //         style: TextStyle(
              //             color: Colors.white24,
              //             fontSize: 10,
              //             decoration: TextDecoration.none)),
              //   },
              //   onValueChanged: (newValue) {
              //     debugPrint('value changed : $newValue');
              //     consumer.changeCalibrationType(newValue as int);
              //   },
              //   groupValue: consumer.calibrationType,
              //   unselectedColor: Colors.white12,
              //   selectedColor: Colors.white38,
              //   pressedColor: Colors.white38,
              //   borderColor: Colors.white12,
              //   padding: const EdgeInsets.all(8),
              // )
            ],
          ),
        ),
        if (consumer.hasCaliData)
          Container(
            width: double.maxFinite,
            height: 1,
            color: Colors.white24,
          ),
        // if (consumer.hasCaliData)
        //   Container(
        //     width: double.maxFinite,
        //     color: Colors.white12,
        //     child: TextButton(
        //         onPressed: () {
        //           consumer.saveCalibrationData();
        //           _showSavedDialog(context);
        //         },
        //         child: const Text(
        //           'Save Calibration Data to local',
        //           style: TextStyle(color: Colors.white),
        //         )),
        //   ),
        const Text(
            '(시선 추적이 활성화된 경우에만 보정을 수행할 수 있습니다.)',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        // Container(
        //   height: 10,
        // ),
        // if (consumer.isUserOption)
        //   const UserSatatusWidget(), // UserSatatusWidget: 사용자 상태를 표시하는 위젯입니다.
      ],
    );
  }
}
