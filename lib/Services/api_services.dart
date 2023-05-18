import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bwageul/Models/article_info_model.dart';
import 'package:bwageul/Models/article_bookmark_model.dart';
import 'package:bwageul/Models/reading_result_model.dart';
import 'package:bwageul/Models/user_info_model.dart';
import 'package:bwageul/Models/word_bookmark_model.dart';
import 'package:bwageul/Models/word_info_model.dart';
import 'package:bwageul/Models/word_quiz_model.dart';
import 'package:bwageul/Services/storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:bwageul/Models/article_and_quiz.dart';

class ApiService {
  static const String baseUrl = // API 요청에 필요한 기본 URL 및 헤더 정보
      "http://ec2-3-37-90-240.ap-northeast-2.compute.amazonaws.com";
  static Map<String, String> headers = {
    "Content-type": "application/json; charset=utf-8",
    'Accept': 'application/json'
  };

  // 회원가입 요청을 처리합니다. 지정된 닉네임, 아이디, 비밀번호 및 역할 정보를 바탕으로
  // 서버에 POST 요청을 전송하여 회원가입을 시도합니다.
  // 닉네임, id, pw를 전달받음
  static Future<void> signUp(
      String nickname, String id, String password) async {
    final url = Uri.parse('$baseUrl/users');
    var userInfo = {
      // Map 자료구조
      'id': id,
      'nickname': nickname,
      'password': password,
      'role': 'ROLE_USER'
    };

    var response = await http.post(
      // http.post 메서드를 사용하여 서버에 회원가입 요청을 전송
      // url, headers, body 매개변수를 설정하여 POST 요청을 보냅니다
      // 응답을 기다릴 때 await 키워드를 사용하여 비동기적으로 처리하고 있습니다.
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
        // 응답의 본문이 비어 있지 않은 경우 해당 본문을 해석하고 에러 코드와 메시지를 출력
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      throw Exception('회원가입 실패');
    }
  } //회원가입 함수

  // 로그인 요청을 처리합니다. 지정된 아이디, 비밀번호 및 자동 로그인 여부에 따라 서버에 POST 요청을 전송하여 로그인을 시도합니다.
  // 응답 상태 코드에 따라 성공, 토큰 만료, 실패 등의 작업을 수행합니다.
  // 로그인 요청을 처리합니다. 함수에는 아이디, 비밀번호 및 자동 로그인 여부(isAutoLogin)를 전달해야 함
  static Future<void> login(
      String id, String password, bool isAutoLogin) async {
    final url = Uri.parse('$baseUrl/users/authorize');
    var userInfo = {
      'id': id,
      'password': password,
    };
    var response = await http.post(url,
        headers: headers,
        body: jsonEncode(
            userInfo)); // url, headers, body 매개변수를 설정하여 POST 요청을 보냅니다

    if (response.statusCode == 200) {
      // 로그인 성공
      print('${userInfo['id']!} 로그인 성공');
      var body = jsonDecode(response.body);
      saveAccessToken(body['data']
          ['access_token']); // 'data' 키 값의 value 중, 'access_token' 키 값을 저장
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

  // 로그아웃 요청을 처리합니다. 현재 로그인된 사용자에 대한 정보와 액세스 토큰을 서버에 POST 요청을 전송하여 로그아웃을 시도한다.
  // 응답 상태 코드에 따라 성공, 토큰 만료, 실패 등의 작업을 수행합니다.
  static Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/users/logout');
    var userInfo;
    final String accessToken;
    if (await isLoggedIn()) {
      userInfo = {"user_id": await getUserId()};
      accessToken = (await getAccessToken())!;
    } else
      throw Exception("로그인 정보 없음");

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

  // 자동 로그인 요청을 처리합니다. 저장된 액세스 토큰을 사용하여 서버에 GET 요청을 전송하여 자동 로그인을 시도합니다.
  // 응답 상태 코드에 따라 성공 또는 실패를 판단하고, 성공 시 사용자 ID를 저장합니다.
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

  // 토큰 갱신 요청을 처리합니다. 저장된 액세스 토큰을 사용하여 서버에 POST 요청을 전송하여 토큰을 갱신합니다.
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
  } // 토큰 갱신 함수

  // 토큰 갱신 함수
  // 사용자 정보 조회 요청을 처리합니다. 지정된 사용자 ID를 사용하여 서버에 GET 요청을 전송하여 사용자 정보를 조회합니다.
  // 응답 상태 코드에 따라 성공, 토큰 만료, 실패 등의 작업을 수행합니다.
  static Future<UserInfoModel> getUserInfoById(String id) async {
    UserInfoModel model;
    final accessToken = await getAccessToken();
    final url = Uri.parse('$baseUrl/users/$id');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      model = UserInfoModel.fromJson(body['data']);
      return model;
    } else if (response.statusCode == 401) {
      // 토큰 만료
      await updateToken();
      return getUserInfoById(id);
    } else {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception("회원 정보 불러오기 실패");
    }
  } // 회원 정보 가져오기

  // 프로필 이미지 변경 요청을 처리합니다. 사용자 ID와 액세스 토큰을 사용하여 서버에 POST 요청을 전송하여 프로필 이미지를 업로드한다.
  // 응답 상태 코드에 따라 성공 또는 실패를 판단하고, 성공 시 업로드된 이미지의 URL을 반환
  static Future<String> changeProfileImage(XFile image) async {
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
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    final response = await request.send();
    if (response.statusCode == 200) {
      // 성공적으로 업로드 완료
      print('프로필 사진이 서버에 업로드되었습니다.');
      final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData);
      print(parsedData);
      return parsedData['data']['url'];
    } else {
      // 업로드 실패
      print('프로필 사진 업로드에 실패했습니다.');
      final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData);
      print(parsedData);
      throw Exception('프로필 사진 업로드 중 오류 발생');
    }
  } // 프로필 이미지 변경

  static Future<List<WordQuizModel>> getWordQuiz() async {
    List<WordQuizModel> modelList = [];
    final userId = await getUserId();
    final accessToken = await getAccessToken();
    final url = Uri.parse('$baseUrl/quiz/$userId');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      // 성공
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      for (int i = 0; i < body['data'].length; i++) {
        modelList.add(WordQuizModel.fromJson(body['data'][i]));
      }
      return modelList;
    } else if (response.statusCode == 401) {
      // 토큰 만료
      await updateToken();
      return getWordQuiz();
    } else {
      // 이외의 에러
      if (response.body != null) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        print(body);
      }
      throw Exception("어휘 퀴즈 정보 불러오기 실패");
    }
  } // 어휘 퀴즈 정보 불러오기

  static Future<void> sendWordQuiz(
      int quizId, int quizChoice, String quizResult) async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    final url = Uri.parse('$baseUrl/quiz');
    var input = {
      'user_id': userId,
      'quiz_id': quizId,
      'quiz_choice': quizChoice,
      'quiz_result': quizResult
    };

    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(input));

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception('어휘 퀴즈 결과 제출 실패');
    }
  } // 어휘 퀴즈 결과 제출

  static Future<List<ArticleInfoModel>> fetchArticleList(int category) async {
    List<ArticleInfoModel> articleList = [];
    final userId = await getUserId();
    final accessToken = await getAccessToken();
    final url = Uri.parse("$baseUrl/problem/users/$userId?category=$category");

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print("fetchArticleList() 글 -> ${body['data']}");
      if (body['data'] != null) {
        for (int i = 0; i < body['data'].length; i++) {
          articleList.add(ArticleInfoModel.fromJson(body['data'][i]));
        }
        return articleList;
      }
      throw Exception('body[\'data\'] 가져오는데 에러 발생..');
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print("articleList() 글 -> ${body['data']}");
      throw Exception("글 목록 가져오기 실패");
    }
  } // 글 목록 가져오기. 1: 인문, 2: 사회, 3: 과학

  static Future<ArticleAndQuiz> fetchArticleContents(int problemId) async {
    final accessToken = await getAccessToken();
    final url = Uri.parse("$baseUrl/problem/$problemId");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('fetchArticleContents(problemId) -> ${body['data']}');
      return ArticleAndQuiz.fromJson(body['data']);
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('articleContents(problemId 1) = 브람스 글 -> $body');
      throw Exception('글+문제 내용 가져오기 실패');
    }
  } // 문제 내용 (글 본문 + 추가 문제)

  static Future<ReadingResultModel> articleReadingResult(int problemId) async {
    final userId = await getUserId();
    final accessToken = await getAccessToken();
    //final problemId = await getProblemId();
    final url = Uri.parse("$baseUrl/problem/$problemId/users/$userId");

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('문제 풀이 결과 호출 -> ${body['data']}');
      return ReadingResultModel.fromJson(body['data']);
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception('문제 풀이 결과 리턴 실패');
    }
  } // 문제 풀이 결과 가져오기. pid 리턴함

  static Future<List<WordInfoModel>> dictionaryResult(String word) async {
    List<WordInfoModel> wordList = [];
    final userId = await getUserId();
    final accessToken = await getAccessToken();
    var input = {"id": userId, "keyword": word};
    final url = Uri.parse("$baseUrl/word");
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(input));

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('사전 -> $body');
      if (body['data'] != null) {
        for (int i = 0; i < body['data'].length; i++) {
          wordList.add(WordInfoModel.fromJson(body['data'][i]));
          // print(body['data'][0]);
        }
        return wordList;
      }
      throw Exception('body[\'data\'] 가져오는데 에러 발생..');
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('사전 -> $body');
      throw Exception('사전 검색 결과 가져오기 실패');
    }
  } // 사전에 "word"에 대한 검색 결과 리턴

  static Future<Map<String, dynamic>> sendProblemSolved(
      List<String> keywordList,
      String topicSentences,
      String summarization,
      List<int> choiceList,
      List<String> resultList,
      int problemId) async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    var input = {
      "user_id": userId,
      "keyword": keywordList,
      "sentence": topicSentences,
      "summarization": summarization,
      "quiz_id": [1, 2, 3],
      "quiz_choice": choiceList,
      "quiz_result": resultList,
      "start_time": "00:00:00",
      "finish_time": "00:00:00",
      "total_time": "00:00:00"
    };
    final url = Uri.parse("$baseUrl/problem/$problemId");
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(input));
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('sendProblemSolved -> ${body['data']}');
      print('sendProblemSolved -> ${body['data'].runtimeType}');
      print('sendProblemSolved -> ${body['data']['problem_id']}');

      return body['data'];
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception("문제 풀이 결과 보내기 실패");
    }
  } // 문제 풀이: 글 읽고, 문제 푼 결과 서버에 보내기. problem_id & ai_summarization 리턴

  static Future<void> problemBookmark(int problemId) async {
    //final problemId = await getProblemId();
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    final url = Uri.parse('$baseUrl/problem/$problemId/bookmark');
    var input = {'user_id': userId};
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(input));
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('북마크 여부 보내기 problemBookmark() 호출: $body');
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('북마크 여부 보내기 problemBookmark() 호출: $body');
      throw Exception("북마크 api 호출 실패");
    }
  } // 글의 북마크 여부 보내기

  static Future<List<ArticleBookmarkModel>> getProblemBookmarkList(
      int category) async {
    // 1:인문, 2:사회, 3:과학
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    final url =
        Uri.parse('$baseUrl/problem/bookmark/users/$userId?category=$category');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final data = body['data'] as List<dynamic>;
      List<ArticleBookmarkModel> bookmarkList = data
          .map((item) =>
              ArticleBookmarkModel.fromJson(item as Map<String, dynamic>))
          .toList();
      // print('북마크된 글 리스트 호출 : ${body['data']}');
      return bookmarkList;
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      // print('북마크된 글 리스트 호출 : $body');
      throw Exception("글 북마크 리스트 api 호출 실패");
    }
  } // 북마크된 글의 리스트 가져오기

  static Future<void> wordBookmark(
      int wordId, String wordNm, String wordMean) async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    final url = Uri.parse('$baseUrl/word/$wordId/bookmark');
    var input = {'user_id': userId, 'word_nm': wordNm, 'word_mean': wordMean};
    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(input));
    // body에 word_nm, word_mean
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      // print('단어 북마크 여부 보내기 wordBookmark() 호출: $body');
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      // print('단어 북마크 여부 보내기 wordBookmark() 호출: $body');
      throw Exception("북마크 api 호출 실패");
    }
  } // 단어 북마크 여부 보내기

  static Future<List<WordBookmarkModel>> getWordBookmarkList() async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    final url = Uri.parse('$baseUrl/word/bookmark/users/$userId');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final data = body['data'] as List<dynamic>;
      List<WordBookmarkModel> wordBookmarkList = data
          .map((item) =>
              WordBookmarkModel.fromJson(item as Map<String, dynamic>))
          .toList();
      // print('북마크된 단어 리스트 호출 : ${body['data']}');
      return wordBookmarkList;
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      // print('북마크된 단어 리스트 호출 : $body');
      throw Exception("글 북마크 리스트 api 호출 실패");
    }
  } // 북마크된 단어 리스트 가져오기
}
