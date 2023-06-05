enum GazeTrackerState {
  // GazeTrackerState는 Gaze Tracker의 상태를 정의하는 열거형(Enumeration)입니다. 각각의 상태는 다음과 같이 정의되어 있습니다
  first, // first: Gaze Tracker의 초기 상태를 나타냅니다. 이 상태는 초기화 전에 사용될 수 있습니다.
  idle, // idle: Gaze Tracker가 대기 상태인 것을 나타냅니다. 초기화가 완료되고 트래킹이 시작되기 전의 상태입니다.
  initializing, // initializing: Gaze Tracker 초기화 중인 것을 나타냅니다. 초기화 과정이 진행 중일 때 사용됩니다.
  initialized,// initialized: Gaze Tracker가 초기화된 상태를 나타냅니다. 초기화가 완료되었고 트래킹을 시작할 준비가 된 상태입니다.
  start,// start: Gaze Tracker 트래킹이 시작된 상태를 나타냅니다. 시선 추적이 활성화되고 데이터가 수집되고 있는 상태입니다.
  calibrating,// calibrating: Gaze Tracker의 캘리브레이션 진행 중인 상태를 나타냅니다. 사용자의 시선에 대한 보정 및 정확도 향상을 위한 과정이 진행 중입니다.
}
