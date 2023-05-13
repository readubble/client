import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://ec2-3-37-90-240.ap-northeast-2.compute.amazonaws.com";
  static Map<String, String> headers = {"Content-type": "application/json"};

  static Future<void> signUp(
      String nickname, String id, String password) async {
    final url = Uri.parse('$baseUrl/users');
    var userInfo = {
      'id': id,
      'nickname': nickname,
      'password': password,
      'role': 'ROLE_USER'
    };

    var response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(userInfo),
    );
    if (response.statusCode == 200) {
      // 회원가입 성공
      print('회원가입 성공');
    }
    // 회원가입 실패
    else {
      if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      throw Exception('회원가입 실패');
    }
  } //회원가입 함수

  static Future<void> login(String id, String password) async {
    final url = Uri.parse('$baseUrl/users/authorize');
    var userInfo = {
      'id': id,
      'password': password,
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(userInfo));
    if (response.statusCode == 200) {
      // 로그인 성공
      print('로그인 성공');
      var body = jsonDecode(response.body);
      print('Error Code: ${body['code']} / Error Message: ${body['message']}');
      print(
          'Access token: ${body['data']['access_token']} / Refresh token: ${body['data']['refresh_token']}');
    } else {
      if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
        print(
            'Access token: ${body['data']['access_token']} / Refresh token: ${body['data']['refresh_token']}');
      }
      throw Exception('회원가입 실패');
    }
  }
}
