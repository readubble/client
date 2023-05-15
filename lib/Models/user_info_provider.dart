import 'package:bwageul/Models/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _user;
  int? daysFromSignUp;
  UserInfoModel? get user => _user;

  int getDaysFromSignUp() {
    // 0일째 성장 중
    if (_user != null) {
      final now = DateTime.now(); // 현재 시간
      final date = DateFormat('yy-MM-dd')
          .parse(_user!.date); // 입력된 날짜 문자열을 DateTime 객체로 변환
      final difference = now.difference(date).inDays;

      return (difference + 1); // 오늘부터 1일을 기준으로 해야 하므로 1을 더해줌
    } else {
      return 0;
    }
  }

  void setUser(UserInfoModel user) {
    _user = user;
    notifyListeners();
  }
}
