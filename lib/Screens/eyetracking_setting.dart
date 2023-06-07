import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../EyetrackingUI/calibration_widget.dart';
import '../EyetrackingUI/camera_handle_widget.dart';
import '../EyetrackingUI/gaze_point_widget.dart';
import '../EyetrackingUI/initialized_fail_dialog_widget.dart';
import '../EyetrackingUI/initialized_widget.dart';
import '../EyetrackingUI/initializing_widget.dart';
import '../EyetrackingUI/loading_circle_widget.dart';
import '../EyetrackingUI/title_widget.dart';
import '../EyetrackingUI/tracking_mode_widget.dart';
import '../Models/app_stage.dart';
import '../Providers/gaze_tracker_provider.dart';

class Eyetracking extends StatefulWidget {
  const Eyetracking({Key? key}) : super(key: key);

  @override
  State<Eyetracking> createState() => _EyetrackingState();
}

class _EyetrackingState extends State<Eyetracking> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GazeTrackerProvider>(context, listen: false).handleCamera();
    Provider.of<GazeTrackerProvider>(context, listen: false)
        .initGazeTracker(); // 초기화. state를 initializing으로 바꿈
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
                color: Colors.white10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const TitleWidget(),
                          Text(
                            '다음 페이지로 이동하여 글을 다 읽은 후 하단의 "트래킹 종료" 버튼을 눌러 트래킹을 종료해주세요!',
                            style: TextStyle(height: 1.5, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              consumer.startTracking(); // 트래킹 시작
                              consumer.startCalibration(); // Calibration 시작
                            },
                            child: Text(
                              '보정을 시작합니다.',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '보정이 끝나면 화면을 바라보는 각도를 고정한 채 다음 페이지로 이동하세요!',
                            style: TextStyle(height: 1.5, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    child: Text('이전 화면으로 이동'),
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/article');
                                  },
                                  child: Container(
                                    child: Text('글 읽기 화면으로 이동'),
                                  )),
                            ],
                          )
                        ]),
                  ),
                )),
          ),
          //if (consumer.state == GazeTrackerState.start) const GazePointWidget(),
          if (consumer.state == GazeTrackerState.initializing)
            const LoadingCircleWidget(),
          if (consumer.state == GazeTrackerState.calibrating)
            const CalibrationWidget(),
          if (consumer.failedReason != null) const InitializedFailDialog()
        ],
      ),
    );
  }
}
