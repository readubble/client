enum MethodString {
  //MethodString은 Gaze Tracker와 관련된 메서드를 나타내는 열거형입니다. 각각의 메서드는 다음과 같이 정의되어 있습니다:
  initGazeTracker, // initGazeTracker: Gaze Tracker를 초기화하는 메서드입니다.
  deinitGazeTracker,// deinitGazeTracker: Gaze Tracker를 종료하는 메서드입니다.
  startTracking,// startTracking: Gaze Tracker의 시선 추적을 시작하는 메서드입니다.
  stopTracking,// stopTracking: Gaze Tracker의 시선 추적을 중지하는 메서드입니다.
  startCalibration,// startCalibration: Gaze Tracker의 캘리브레이션을 시작하는 메서드입니다.
  saveCalibrationData,// saveCalibrationData: 캘리브레이션 데이터를 저장하는 메서드입니다.
  startCollectSamples// startCollectSamples: 샘플 데이터 수집을 시작하는 메서드입니다.
}

// MethodStringExtension은 MethodString 열거형에 대한 확장(extension)입니다.
// 이 확장을 사용하여 각각의 MethodString 값에 대해 해당하는 문자열을 반환하는 convertedText 속성을 정의하고 있습니다.
// 이를 통해 각 메서드에 대응하는 문자열을 간편하게 얻을 수 있습니다.
// 이러한 MethodString과 MethodStringExtension은 Gaze Tracker와의 통신을 관리하는 GazeTrackerProvider 클래스에서 사용됩니다.
// 메서드 호출에 필요한 문자열을 제공하고, 해당 메서드가 실행되는 동작을 처리할 수 있게 도와줍니다.
extension MethodStringExtension on MethodString {
  String get convertedText {
    switch (this) {
      case MethodString.initGazeTracker:
        return "initGazeTracker";
      case MethodString.deinitGazeTracker:
        return "deinitGazeTracker";
      case MethodString.startTracking:
        return "startTracking";
      case MethodString.stopTracking:
        return "stopTracking";
      case MethodString.startCalibration:
        return "startCalibration";
      case MethodString.saveCalibrationData:
        return "saveCalibrationData";
      case MethodString.startCollectSamples:
        return "startCollectSamples";
    }
  }
}
