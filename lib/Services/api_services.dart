import 'dart:convert';
import 'package:bwageul/Services/storage.dart';
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
      //print('login함수 -> Access token: ${body['data']['access_token']} / Refresh token: ${body['data']['refresh_token']}');
      saveAccessToken(body['data']['access_token']);
      //getAccessToken().then((value) => print(value));
      saveRefreshToken(body['data']['refresh_token']);
      saveUserId(userInfo['id']!);
      //getUserId().then((value) => print(value));
    } else if (response.statusCode == 401) {
      // 토큰 만료 에러
      final url2 = Uri.parse('$baseUrl/users/authorize/token');
      final accessToken = getAccessToken();
      var refreshToken = {'refresh_token': getRefreshToken()};

      final response2 = await http.post(url2,
          headers: {
            'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
            'Content-Type': 'application/json',
          },
          body: jsonEncode(refreshToken));
      if (response2.statusCode == 200) {
        // 토큰 갱신 성공
        print('토큰 갱신 성공');
        var body = jsonDecode(response.body);
        final newAccessToken = body['data']['access_token'];
        saveAccessToken(newAccessToken); // storage에 새로운 access token 다시 저장
      }
    } else {
      //에러
      {
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

  static Future<void> logout(String id) async {
    final url = Uri.parse('$baseUrl/users/logout');
    var userInfo = {'user_id': id};
    var response =
        await http.post(url, headers: headers, body: jsonEncode(userInfo));
    if (response.statusCode == 200) {
      // 로그아웃 성공
      print('로그아웃 성공');
      var body = jsonDecode(response.body);
    } else {
      if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
    }
  } //로그아웃
}
