import 'package:bwageul/licenseKey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bwageul/Models/app_stage.dart';
import 'package:bwageul/Models/gazetracker_method_string.dart';

class GazeTrackerProvider with ChangeNotifier {
  dynamic state; // state 변수: 현재 Gaze Tracker 상태를 나타내는 변수입니다.
  static const licenseKey = myLicenseKey;
  final _channel = const MethodChannel(
      'samples.flutter.dev/tracker'); // _channel 변수: Gaze Tracker SDK와의 통신을 위한 MethodChannel입니다.
  String? failedReason; //failedReason 변수: 초기화 또는 실행 실패 시 실패 이유를 저장하는 변수입니다.
  // pointX, pointY 변수: Gaze Tracker로부터 받은 시선 좌표를 저장하는 변수입니다.
  var pointX = 0.0;
  var pointY = 0.0;

  // calibration
  double progress = 0.0; //progress 변수: 캘리브레이션 진행 상태를 나타내는 변수입니다.
  // caliX, caliY 변수: 캘리브레이션 진행 중인 좌표를 저장하는 변수입니다.
  var caliX = 0.0;
  var caliY = 0.0;
  bool hasCaliData = false; //hasCaliData 변수: 캘리브레이션 데이터가 있는지 여부를 나타내는 변수입니다.
  double attention = 0.0; // attention 변수: 사용자의 집중도를 나타내는 변수입니다.
  bool isUserOption = false; //isUserOption 변수: 사용자 옵션 활성화 여부를 나타내는 변수입니다.

  int calibrationType = 5; //calibrationType 변수: 캘리브레이션 타입을 나타내는 변수입니다.
  bool isDrowsiness = false; //isDrowsiness 변수: 사용자의 졸음 여부를 나타내는 변수입니다.
  bool isBlink = false; //isBlink 변수: 사용자의 눈깜빡임 여부를 나타내는 변수입니다.
  bool savedCalibrationData =
      false; //savedCalibrationData 변수: 캘리브레이션 데이터가 저장되었는지 여부를 나타내는 변수입니다.

  double _scrollOffset = 0.0;
  double get scrollOffset => _scrollOffset;
  void setScrollOffset(double value) {
    if (_scrollOffset != value) {
      _scrollOffset = value;
      notifyListeners();
    }
  }

  bool _startReading = false; // '다음으로 넘어가기' 버튼을 누른 이후에만 gazeCount가 세어지도록 하는 변수
  bool get startReading => _startReading;
  void setStartReading() {
    _startReading = true;
    notifyListeners();
  }

  List<List<int>> gazeCount = List.generate(
      200,
      (index) =>
          List<int>.filled(15, 0)); // 15 * 30 2차원 배열. 시선이 머물렀던 횟수를 세서 저장.
  List<List<int>> topItems = [];

  GazeTrackerProvider() {
    state = GazeTrackerState.first;
    setMessageHandler();
    checkCamera();
  }

  void setMessageHandler() {
    _channel.setMethodCallHandler((call) async {
      debugPrint("setMessageHandler : ${call.method}");
      if (call.method == "onGaze") {
        final xy = call.arguments;
        _onGaze(xy[0] as double, xy[1] as double);
      } else if (call.method == "getInitializedResult") {
        debugPrint("argument : ${call.arguments}");
        _getInitializedResult(call.arguments);
      } else if (call.method == "onStatus") {
        _onTrackingStatus(call.arguments);
      } else if (call.method == "onCalibrationNext") {
        _onCalibrationNext(call.arguments);
      } else if (call.method == "onCalibrationProgress") {
        _onCalibrationProgress(call.arguments);
      } else if (call.method == "onCalibrationFinished") {
        _onCalibrationFinished();
      } else if (call.method == "onDrowsiness") {
        _onDrowsiness(call.arguments);
      } else if (call.method == "onAttention") {
        _onAttentions(call.arguments);
      } else if (call.method == "onBlink") {
        _onBlink(call.arguments);
      }
    });
  }

  void changeUserStatusOption(bool isOption) {
    isUserOption = isOption;
    notifyListeners();
  }

  void _onAttentions(dynamic result) {
    if (state != GazeTrackerState.calibrating) {
      attention = result[0];
      notifyListeners();
    }
  }

  void _onDrowsiness(dynamic result) {
    if (state != GazeTrackerState.calibrating) {
      isDrowsiness = result[0];
      notifyListeners();
    }
  }

  void _onBlink(dynamic reuslt) {
    if (state != GazeTrackerState.calibrating) {
      isBlink = reuslt[0];
      notifyListeners();
    }
  }

  void _onTrackingStatus(dynamic result) {
    if (result == null) {
      _setTrackerState(GazeTrackerState.start);
    } else {
      _setTrackerState(GazeTrackerState.initialized);
    }
  }

  void _onCalibrationNext(dynamic result) {
    if (state != GazeTrackerState.calibrating) {
      _setTrackerState(GazeTrackerState.calibrating);
    }
    caliX = result[0];
    caliY = result[1];
    notifyListeners();
    _channel.invokeMethod(MethodString.startCollectSamples.convertedText);
  }

  void _onCalibrationProgress(dynamic result) {
    progress = result[0];
    notifyListeners();
  }

  void _onCalibrationFinished() {
    hasCaliData = true;
    _setTrackerState(GazeTrackerState.start);
  }

  void _onGaze(double x, double y) {
    if (x < 0) {
      x = 0;
    } else if (x >= 450) {
      x = 449;
    }
    if (y < 0) {
      y = 0;
    } else if (y >= 6000) {
      y = 5999;
    }
    pointX = x;
    pointY = y;
    pointY += _scrollOffset;
    debugPrint(
        "gaze x : $pointX, y: $pointY, timestamp: ${DateFormat('HH:mm:ss.SSS').format(DateTime.now())}");
    if (_startReading) {
      gazeCount[(pointY ~/ 30).toInt()][(pointX ~/ 30).toInt()] += 1;
    }
    notifyListeners();
  }

  void _getInitializedResult(dynamic result) {
    debugPrint("_getInitializedResult result = ${result[0]}");
    if (result[0] == 1) {
      _setTrackerState(GazeTrackerState.initialized);
    } else {
      failedReason = "Init Failed error code ${result[1]}";
      notifyListeners();
    }
  }

  Future<void> checkCamera() async {
    final isGrated = await Permission.camera.isGranted;
    if (isGrated) {
      _setTrackerState(GazeTrackerState.idle);
    }
  }

  Future<void> handleCamera() async {
    final status = await Permission.camera.request();
    debugPrint(status.isGranted.toString());
    if (status.isGranted) {
      _setTrackerState(GazeTrackerState.idle);
    }
  }

  Future<void> initGazeTracker() async {
    failedReason = null;
    _setTrackerState(GazeTrackerState.initializing);
    final String result = await _channel.invokeMethod(
        MethodString.initGazeTracker.convertedText, {
      'license': licenseKey,
      'useStatusOption': isUserOption ? "true" : "false"
    });
    debugPrint('result : $result');
  }

  void deinitGazeTracker() {
    failedReason = null;
    _channel.invokeMethod(MethodString.deinitGazeTracker.convertedText, {});
    _setTrackerState(GazeTrackerState.idle);
  }

  void startTracking() {
    _channel.invokeMethod(MethodString.startTracking.convertedText);
  }

  void stopTracking() {
    _channel.invokeMethod(MethodString.stopTracking.convertedText);

    List<MapEntry<int, int>> flattenedArray =
        gazeCount.asMap().entries.expand((entry) {
      int rowIndex = entry.key; // (x,y)
      List<int> row = entry.value;
      return row.asMap().entries.map(
          (entry) => MapEntry(entry.value, rowIndex * row.length + entry.key));
    }).toList();

    flattenedArray.sort((a, b) => b.key.compareTo(a.key)); // 내림차순으로 정렬

    List<int> topIndices = flattenedArray
        .take(20)
        .map((entry) => entry.value)
        .toList(); // 최빈값 상위 10개의 인덱스 선택.

    topItems = topIndices.map((index) {
      int row = index ~/ gazeCount[0].length;
      int col = index % gazeCount[0].length;
      return [row, col]; // 선택된 인덱스 반환
    }).toList();

    for (int i = 0; i < 20; i++) {
      debugPrint('행 ${topItems[i][0]}, 열 ${topItems[i][1]}');
    }
  }

  void _setTrackerState(GazeTrackerState state) {
    this.state = state;
    notifyListeners();
  }

  void startCalibration() {
    _channel.invokeMethod(
        MethodString.startCalibration.convertedText, calibrationType);
  }

  void saveCalibrationData() {
    hasCaliData = false;
    savedCalibrationData = true;
    _channel.invokeMethod(MethodString.saveCalibrationData.convertedText);
    notifyListeners();
  }

  void chageIdleState() {
    failedReason = null;
    _setTrackerState(GazeTrackerState.idle);
  }
}
