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
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);

    return Stack(
      children: <Widget>[
        SafeArea(
          child: Container(
              color: Colors.white10,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const TitleWidget(),
                      Consumer<GazeTrackerProvider>(
                        // 조건부 렌더링: GazeTrackerProvider의 상태에 따라 GazePointWidget, LoadingCircleWidget,
                        // CalibrationWidget, InitializedFailDialog를 조건부로 렌더링합니다.
                        builder: (context, gazetracker, child) {
                          switch (gazetracker.state) {
                            case GazeTrackerState.first:
                              return const CameraHandleWidget();
                            case GazeTrackerState.idle:
                              return const InitializingWidget();
                            case GazeTrackerState.initialized:
                              return const InitializedWidget();
                            case GazeTrackerState.start:
                            case GazeTrackerState.calibrating:
                              return const TrackingModeWidget();
                            default:
                              return const InitializingWidget();
                          }
                        },
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
              )),
        ),
        if (consumer.state == GazeTrackerState.start) const GazePointWidget(),
        if (consumer.state == GazeTrackerState.initializing)
          const LoadingCircleWidget(),
        if (consumer.state == GazeTrackerState.calibrating)
          const CalibrationWidget(),
        if (consumer.failedReason != null) const InitializedFailDialog()
      ],
    );
  }
}
