import 'package:bwageul/Models/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfoProvider with ChangeNotifier {
  UserInfoModel? _user;
  int? daysFromSignUp;
  UserInfoModel? get user => _user;

  String? get nickname => _user?.nickname;

  int getDaysFromSignUp() {
    if (_user != null) {
      final now = DateTime.now(); // 현재 시간
      final date = DateFormat('yy-MM-dd').parse(_user!.date);
      final difference = now.difference(date).inDays;
      return (difference);
    } else {
      return 0;
    }
  }

  void setUser(UserInfoModel user) {
    _user = user;
    notifyListeners();
  }

  void setProfileUrl(String url) {
    _user?.profile = url;

    notifyListeners();
  }

  String? getProfileUrl() {
    if (_user != null) {
      return _user!.profile;
    }
    return null;
  }
}
