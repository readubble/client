import 'package:flutter/cupertino.dart';

//이 위젯은 저장 완료 대화상자를 표시합니다.
//SaveDataDialogWidget은 저장 완료 대화상자를 나타내며, 사용자에게 데이터 저장이 완료되었음을 알려줍니다.
// 사용자는 "Ok" 버튼을 눌러 대화상자를 닫을 수 있습니다. 이 위젯은 iOS 스타일의 대화상자를 사용하여 일관된 사용자 경험을 제공합니다.
class SaveDataDialogWidget extends StatelessWidget {
  const SaveDataDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CupertinoAlertDialog: iOS 스타일의 경고 대화상자를 나타내는 위젯입니다.
    // title: 대화상자의 제목으로, Text 위젯으로 구성됩니다.
    // content: 대화상자의 내용으로, Text 위젯으로 구성됩니다.
    // actions: 대화상자의 액션 버튼 목록으로, CupertinoDialogAction 위젯의 리스트로 구성됩니다.
    return CupertinoAlertDialog(
      title: const Text('Save'),
      content: const Text('Calibration Data Save Done'),
      actions: <CupertinoDialogAction>[
        // CupertinoDialogAction: 대화상자의 액션 버튼을 나타내는 위젯입니다.
        // isDefaultAction: 이 액션이 기본 액션임을 나타내며, 액션의 텍스트를 굵게 표시합니다.
        // onPressed: 액션 버튼이 클릭되었을 때 호출되는 콜백 함수입니다. 이 경우 Navigator.pop(context)를 호출하여 대화상자를 닫습니다.
       // child: 액션 버튼에 표시되는 텍스트로, Text 위젯으로 구성됩니다.
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
