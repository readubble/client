enum GazeTrackerState {
  first, // Gaze Tracker의 초기 상태
  idle, // 초기화가 완료되고 트래킹이 시작되기 전
  initializing, // 초기화 과정이 진행 중
  initialized, // 초기화가 완료되었고 트래킹을 시작할 준비가 된 상태
  start, // 시선 추적이 활성화되고 데이터가 수집되고 있는 상태
  calibrating, // Gaze Tracker의 캘리브레이션 진행 중인 상태
}
