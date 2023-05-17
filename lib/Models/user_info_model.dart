class UserInfoModel {
  String nickname, profile, date, level;
  int exp;

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'],
        date = json['date'],
        level = json['level'],
        exp = json['exp'],
        profile = json['profile'];
}
