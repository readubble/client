import 'package:bwageul/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/calibration_widget.dart';
import '../Models/app_stage.dart';
import '../Providers/gaze_tracker_provider.dart';

class Eyetracking extends StatefulWidget {
  const Eyetracking({Key? key}) : super(key: key);

  @override
  State<Eyetracking> createState() => _EyetrackingState();
}

class _EyetrackingState extends State<Eyetracking> {
  bool trackingStart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GazeTrackerProvider>(context, listen: false)
        .handleCamera()
        .then((_) {
      Provider.of<GazeTrackerProvider>(context, listen: false)
          .initGazeTracker(); // 초기화. state를 initializing으로 바꿈
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          trackingStart = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<GazeTrackerProvider>(context);
    consumer.startTracking();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
                color: Colors.white10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            '시선 추적 설정',
                            style: TextStyle(
                                decoration: TextDecoration.none, fontSize: 24),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            // Divider: 수평 구분선을 나타내는 위젯입니다. 회색 계통의 색상을 사용합니다.
                            color: Colors.grey[800],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            '보정이 끝나면 화면을 바라보는 각도를 고정한 채 다음 페이지로 이동하세요!',
                            style: TextStyle(height: 1.5, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          !trackingStart
                              ? Text("시선 추적 준비 중..",
                                  style: TextStyle(
                                      fontSize: 20, color: myColor.shade100))
                              : TextButton(
                                  onPressed: () {
                                    consumer.startCalibration(); // 트래킹 시작
                                    // Calibration 시작
                                  },
                                  child: const Text(
                                    "클릭하여 보정 시작",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/article');
                              consumer.setStartReading();
                            },
                            child: const Text(
                              '다음 페이지로 이동',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
                  ),
                )),
          ),
          Positioned(
            top: 30,
            left: 15,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 35,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          if (consumer.state == GazeTrackerState.calibrating)
            const CalibrationWidget(),
        ],
      ),
    );
  }
}
