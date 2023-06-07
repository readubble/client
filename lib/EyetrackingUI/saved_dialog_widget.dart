import 'package:flutter/cupertino.dart';

//이 위젯은 저장 완료 대화상자를 표시합니다.
//SaveDataDialogWidget은 저장 완료 대화상자를 나타내며, 사용자에게 데이터 저장이 완료되었음을 알려줍니다.
// 사용자는 "Ok" 버튼을 눌러 대화상자를 닫을 수 있습니다. 이 위젯은 iOS 스타일의 대화상자를 사용하여 일관된 사용자 경험을 제공합니다.
class SaveDataDialogWidget extends StatelessWidget {
  const SaveDataDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Save'),
      content: const Text('Calibration Data Save Done'),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
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
