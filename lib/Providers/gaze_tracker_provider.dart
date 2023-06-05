import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:bwageul/Models/app_stage.dart';
import 'package:bwageul/Models/gazetracker_method_string.dart';

//이 클래스는 Gaze Tracker SDK와의 통신 및 상태 관리를 담당하는 Provider입니다.
// 이 클래스는 Gaze Tracker SDK의 이벤트 및 메소드 호출을 처리하기 위한 _channel.setMethodCallHandler() 메소드를 사용합니다.
// 각 이벤트 및 메소드 호출은 해당 메소드 내에서 처리되며,
// 이를 통해 시선 좌표, 초기화 결과, 트래킹 상태, 캘리브레이션 진행 상태 등의 정보를 받아 처리합니다.
// 또한, GazeTrackerProvider 클래스는 애플리케이션의 다른 부분에서 상태 변경을 알기 위해 notifyListeners()를 호출하고,
// 해당 상태를 소비하는 위젯들에게 변경 사항을 알립니다.
// 상태 변경 메소드들은 notifyListeners()를 호출하여 변경 사항을 알리고,
// 상태에 따라 애플리케이션의 다른 부분에 필요한 작업을 수행합니다.
// 이 클래스는 Gaze Tracker SDK와의 통신과 애플리케이션의 상태 관리를 담당하며, Gaze Tracker의 초기화, 트래킹 시작/중지, 캘리브레이션 등의 기능을 제공합니다.
class GazeTrackerProvider with ChangeNotifier {
  dynamic state; // state 변수: 현재 Gaze Tracker 상태를 나타내는 변수입니다.
  static const licenseKey =
      'dev_w37r4m0nmz4zn6h681akbbtb0e2qqbw2s13guavp'; // Please enter the key value for development issued by the SeeSo.io
  final _channel = const MethodChannel(
      'samples.flutter.dev/tracker'); // _channel 변수: Gaze Tracker SDK와의 통신을 위한 MethodChannel입니다.
  String? failedReason; //failedReason 변수: 초기화 또는 실행 실패 시 실패 이유를 저장하는 변수입니다.
  // gaze X,Y
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

  // void changeCalibrationType(int cType) {
  //   calibrationType = cType;
  //   notifyListeners();
  // }

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
    debugPrint(
        "gaze x : $x, y: $y, ${DateFormat('HH:mm:ss.SSS').format(DateTime.now())}");
    pointX = x;
    pointY = y;
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
