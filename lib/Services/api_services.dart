import 'dart:convert';
import 'dart:io';
import 'package:bwageul/Models/user_info_model.dart';
import 'package:bwageul/Services/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ApiService {
  static const String baseUrl =
      "http://ec2-3-37-90-240.ap-northeast-2.compute.amazonaws.com";
  static Map<String, String> headers = {
    "Content-type": "application/json; charset=utf-8",
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
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      throw Exception('회원가입 실패');
    }
  } //회원가입 함수

  static Future<void> login(
      String id, String password, bool isAutoLogin) async {
    final url = Uri.parse('$baseUrl/users/authorize');
    var userInfo = {
      'id': id,
      'password': password,
    };
    var response =
        await http.post(url, headers: headers, body: jsonEncode(userInfo));

    if (response.statusCode == 200) {
      // 로그인 성공
      print('${userInfo['id']!} 로그인 성공');
      var body = jsonDecode(response.body);
      saveAccessToken(body['data']['access_token']);
      saveRefreshToken(body['data']['refresh_token']);
      saveUserId(userInfo['id']!);

      // getRefreshToken().then((value) => print('refresh token: $value'));
      // getAccessToken().then((value) => print('access token: $value'));
      // getUserId().then((value) => print(value));

      if (isAutoLogin)
        await ApiService.autoLogin(); // 자동 로그인이 체크되어 있으므로 자동 로그인 함수 호출
    } else if (response.statusCode == 401) {
      // 토큰 만료 에러
      updateToken();
    } else {
      // 로그인 실패
      if (response.body.isEmpty) {
        print('로그인 실패하면 empty body return');
      } else if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
        // print(
        //     'Access token: ${body['data']['access_token']} / Refresh token: ${body['data']['refresh_token']}');
      }
      throw Exception('로그인 실패');
    }
  } //로그인 함수

  static Future<bool> logout() async {
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
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(userInfo));
    if (response.statusCode == 200) {
      // 로그아웃 성공
      print('$userInfo 로그아웃 성공');
      await deleteTokenAndId();
      //getUserId().then((value) => print(value)); // 로그아웃 됐으니까 null
      return true;
    } else if (response.statusCode == 401) {
      // 토큰 만료 에러
      print('토큰 만료 에러 401');
      await updateToken();
      return false;
    } else {
      //로그아웃 실패
      print('로그아웃 실패');
      if (response.body.isNotEmpty) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      return false;
    }
  } //로그아웃 함수

  static Future<void> autoLogin() async {
    final url = Uri.parse('$baseUrl/users/authorize/auto');
    final accessToken =
        await getAccessToken(); // 지금으로선 액세스 토큰이 없음 -> 로그인 함수 호출하고서(액세스 토큰 생기면) 자동 로그인 함수 호출하기

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      // 자동 로그인 성공! 자동 로그인을 선택하면 실제로 로그인을 한 게 아니라 로그인 과정을 생략한 것.
      // 따라서 user_id가 필요한 작업이 있을 때 사용하려고 user_id를 저장해둠.
      print('자동 로그인 성공');
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      saveUserId(body['data']['user_id']);
    } else {
      throw Exception('자동 로그인 실패');
    }
  } // 자동 로그인 함수

  static Future<void> updateToken() async {
    final url = Uri.parse('$baseUrl/users/authorize/token');
    final accessToken = await getAccessToken(); // 토큰 만료 => 이미 토큰이 있다
    var refreshToken = {"refresh_token": await getRefreshToken()};

    // 테스트용
    // getUserId().then((value) => print('update token - userID: $value'));
    // print('update token - Access Token: $accessToken');
    // print('update token - Refresh Token: ${refreshToken['refresh_token']}');

    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(refreshToken));
    if (response.statusCode == 200) {
      // 토큰 갱신 성공
      print('토큰 갱신 성공');
      var body = jsonDecode(response.body);
      final newAccessToken = body['data']['access_token'];
      saveAccessToken(newAccessToken); // storage에 새로운 access token 다시 저장
      getAccessToken()
          .then((value) => print('newly updated access token: $value'));
    } else {
      print('토큰 갱신 실패');
      if (response.body.isNotEmpty) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      throw Exception('토큰 갱신 실패');
    }
  }
  // 토큰 갱신 함수

  static Future<UserInfoModel> getUserInfoById(String id) async {
    UserInfoModel model;
    final accessToken = await getAccessToken();
    final url = Uri.parse('$baseUrl/users/$id');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json', 'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      model = UserInfoModel.fromJson(body);
      //print(body['data']['level'].runtimeType); // level은 String이었다...
      //print("my nickname: " + model.nickname);
      //print("sign up date: " + model.date);
      return model;
    } else if (response.statusCode == 401) {
      // 토큰 만료
      await updateToken();
      return getUserInfoById(id);
    } else {
      var body = jsonDecode(response.body);
      print(body);
      throw Exception("회원 정보 불러오기 실패");
    }
  }

  static Future<void> changeProfileImage(XFile image) async {
    try {
      final id = await getUserId();
      final accessToken = await getAccessToken();
      final url = Uri.parse('$baseUrl/users/$id/profile');
      print("프로필 사진을 서버에 업로드 합니다.");

      final request = http.MultipartRequest('POST', url);

      final file = File(image.path);
      final mimeType = lookupMimeType(file.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(mimeType!),
      );
      request.files.add(multipartFile);

      final response = await request.send();
      if (response.statusCode == 200) {
        // 성공적으로 업로드 완료
        print('프로필 사진이 서버에 업로드되었습니다.');
        final responseData = await response.stream.bytesToString();
        final parsedData = jsonDecode(responseData);
        print(parsedData);
      } else {
        // 업로드 실패
        print('프로필 사진 업로드에 실패했습니다.');
        final responseData = await response.stream.bytesToString();
        final parsedData = jsonDecode(responseData);
        print(parsedData);
      }
    } catch (e) {
      print('프로필 사진 업로드 중 오류 발생 : $e');
    }
  } // 프로필 이미지 변경
}
