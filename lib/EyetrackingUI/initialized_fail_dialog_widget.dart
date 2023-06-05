import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:bwageul/Providers/gaze_tracker_provider.dart';

// 이 위젯은 초기화 실패에 대한 다이얼로그를 표시하는 UI를 제공합니다.
// InitializedFailDialog은 Provider.of<GazeTrackerProvider>(context)를 사용하여
// GazeTrackerProvider의 인스턴스를 가져온 후, 해당 인스턴스의 failedReason 값을 확인하여 초기화 실패 이유를 표시합니다.
// 사용자는 "Ok" 버튼을 클릭하여 다이얼로그를 닫을 수 있으며,
// 버튼 클릭 시 GazeTrackerProvider의 chageIdleState() 메서드를 호출하여 애플리케이션을 초기 상태로 변경합니다.
class InitializedFailDialog extends StatelessWidget {
  const InitializedFailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final consumer: Provider.of<GazeTrackerProvider>(context)를 사용하여 GazeTrackerProvider의 인스턴스를 가져옵니다.
    final consumer = Provider.of<GazeTrackerProvider>(context);
    return CupertinoAlertDialog(
      title: const Text('Failed'),
      // content: 다이얼로그의 내용을 표시하는 위젯입니다.
      // consumer.failedReason 값이 null이 아닌 경우 해당 값을 표시하고, 그렇지 않으면 "unknown"을 표시합니다.
      content: Text(
          consumer.failedReason != null ? consumer.failedReason! : "unknown"),
      //actions: 다이얼로그의 액션 버튼을 정의하는 리스트입니다. 여기서는 하나의 CupertinoDialogAction이 정의되어 있습니다.
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          // isDefaultAction 속성이 true로 설정되어 기본 액션으로 지정되고, 액션의 텍스트가 굵은 텍스트로 표시됩니다.
          // 클릭 이벤트가 발생하면 consumer.chageIdleState()를 호출하여 GazeTrackerProvider의 chageIdleState() 메서드를 실행합니다.
          // 버튼의 텍스트는 "Ok"로 지정됩니다.
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            consumer.chageIdleState();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
