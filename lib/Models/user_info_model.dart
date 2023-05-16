class UserInfoModel {
  String nickname, profile, date, level;
  int exp;

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : nickname = json['data']['nickname'],
        date = json['data']['date'],
        level = json['data']['level'],
        exp = json['data']['exp'],
        profile = json['data']['profile'];
}
