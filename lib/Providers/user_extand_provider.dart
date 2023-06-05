import 'package:flutter/widgets.dart';
// 이 클래스는 사용자 상태 확장 정보의 활성화 및 비활성화를 관리하는 Provider입니다.
// UserExtandProvider 클래스는 애플리케이션의 다른 부분에서 상태 관리를 위해 사용될 수 있습니다.
// 사용자 상태 확장 정보의 활성화 여부를 추적하고, 활성화 상태가 변경될 때 해당 정보를 소비하는 위젯들에게 변경 사항을 알릴 수 있습니다.
// 이를 위해 Provider.of<UserExtandProvider>(context)와 같은 방식으로 UserExtandProvider 인스턴스에 액세스하여 사용할 수 있습니다.
class UserExtandProvider with ChangeNotifier {
  // isExtand 변수: 사용자 상태 확장 정보가 확장된 상태인지를 나타내는 부울 변수입니다. 초기값은 false로 설정됩니다.
  // changeIsExtand() 메서드: isExtand 변수의 값을 토글하여 사용자 상태 확장 정보의 활성화 또는 비활성화 상태를 변경합니다.
  // 그리고 notifyListeners() 메서드를 호출하여 등록된 리스너들에게 상태 변경을 알립니다.
  bool isExtand = false;

  void changeIsExtand() {
    isExtand = !isExtand;
    notifyListeners();
  }
}
