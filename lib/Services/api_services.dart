import 'dart:convert';
import 'package:bwageul/Services/storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://ec2-3-37-90-240.ap-northeast-2.compute.amazonaws.com";
  static Map<String, String> headers = {
    "Content-type": "application/json",
    'Accept': 'application/json'
  };

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
      saveAccessToken(body['data']['access_token']);
      saveRefreshToken(body['data']['refresh_token']);
      saveUserId(userInfo['id']!);

      getAccessToken().then((value) => print(value));
      getUserId().then((value) => print(value));
    } else if (response.statusCode == 401) {
      // 토큰 만료 에러
      final url2 = Uri.parse('$baseUrl/users/authorize/token');
      final accessToken = await getAccessToken(); // 토큰 만료라는 건 이미 토큰이 있다는 뜻이니까!
      var refreshToken = {'refresh_token': await getRefreshToken()};

      final response2 = await http.post(url2,
          headers: {
            'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
            'Content-Type': 'application/json', 'Accept': 'application/json'
          },
          body: jsonEncode(refreshToken));
      if (response2.statusCode == 200) {
        // 토큰 갱신 성공
        print('토큰 갱신 성공');
        var body = jsonDecode(response.body);
        final newAccessToken = body['data']['access_token'];
        saveAccessToken(newAccessToken); // storage에 새로운 access token 다시 저장
      } else {
        throw Exception('토큰 갱신 실패');
      }
    } else {
      // 로그인 실패
      if (response.body.isEmpty) {
        print('로그인 실패하면 empty body return');
      } else if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
        print(
            'Access token: ${body['data']['access_token']} / Refresh token: ${body['data']['refresh_token']}');
      }
      throw Exception('로그인 실패');
    }
  } //로그인 함수

  static Future<void> logout() async {
    final url = Uri.parse('$baseUrl/users/logout');
    var userInfo;
    final String accessToken;
    if (await isLoggedIn()) {
      userInfo = {"user_id": await getUserId()};
      accessToken = (await getAccessToken())!;
    } else
      throw Exception("로그인 정보 없음");

    // user ID, token 잘 들어갔는지 테스트
    // print("NOW User ID: " + userInfo['user_id']);
    // print("NOW Access Token: " + accessToken);

    // 토큰 삭제 테스트
    // print('After delete token and ID');
    // await deleteTokenAndId();
    // if (await isLoggedIn())
    //   print('아직 로그인 상태');
    // else
    //   print('토큰 삭제 완료');
    // getAccessToken().then((value) => print(value));
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json', 'Accept': 'application/json'
        },
        body: jsonEncode(userInfo));
    if (response.statusCode == 200) {
      // 로그아웃 성공
      print('로그아웃 성공');
      await deleteTokenAndId();
      getUserId().then((value) => print(value)); // 로그아웃 됐으니까 null
    } else {
      //로그아웃 실패
      print('로그아웃 실패');
      if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
    }
  } //로그아웃 함수
}
