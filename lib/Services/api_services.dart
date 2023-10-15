import 'dart:convert';
import 'dart:io';
import 'package:bwageul/Models/article_info_model.dart';
import 'package:bwageul/Models/article_bookmark_model.dart';
import 'package:bwageul/Models/reading_result_model.dart';
import 'package:bwageul/Models/user_info_model.dart';
import 'package:bwageul/Models/word_bookmark_model.dart';
import 'package:bwageul/Models/word_info_model.dart';
import 'package:bwageul/Models/word_quiz_model.dart';
import 'package:bwageul/Services/storage.dart';
import 'package:bwageul/secret.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:bwageul/Models/article_and_quiz.dart';

class ApiService {
  static const String baseUrl = Secret.myBaseUrl;
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
      print('회원가입 성공');
    } else {
      if (response.body.isNotEmpty) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      throw Exception('회원가입 실패');
    }
  } //회원가입 함수

  static Future<bool> login(
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

      if (isAutoLogin)
        await ApiService.autoLogin(); // 자동 로그인이 체크되어 있으므로 자동 로그인 함수 호출
      return true;
    } else if (response.statusCode == 401) {
      await updateToken();
      return await login(id, password, isAutoLogin);
    } else {
      // 로그인 실패
      if (response.body.isEmpty) {
        print('로그인 실패하면 empty body return');
      } else if (response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print(
            'Error Code: ${body['code']} / Error Message: ${body['message']}');
      }
      return false; // 로그인 실패!
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

    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(userInfo));
    if (response.statusCode == 200) {
      print('$userInfo 로그아웃 성공');
      await deleteTokenAndId();
      return true;
    } else if (response.statusCode == 401) {
      print('토큰 만료 에러 401');
      await updateToken();
      return false;
    } else {
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

    var response = await http.post(url,
        headers: {
          'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(refreshToken));
    if (response.statusCode == 200) {
      print('토큰 갱신 성공');
      var body = jsonDecode(response.body);
      final newAccessToken = body['data']['access_token'];
      saveAccessToken(newAccessToken); // storage에 새로운 access token 다시 저장
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
      await updateToken();
      return getUserInfoById(id);
    } else {
      var body = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception("회원 정보 불러오기 실패");
    }
  } // 회원 정보 가져오기

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
      print('프로필 사진이 서버에 업로드되었습니다.');
      final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData);
      return parsedData['data']['url'];
    } else {
      print('프로필 사진 업로드에 실패했습니다.');
      final responseData = await response.stream.bytesToString();
      final parsedData = jsonDecode(responseData);
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
      for (int i = 0; i < body['data'].length; i++) {
        modelList.add(WordQuizModel.fromJson(body['data'][i]));
      }
      return modelList;
    } else if (response.statusCode == 401) {
      await updateToken();
      return await getWordQuiz();
    } else {
      if (response.body != null) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        print(body);
      }
      throw Exception("어휘 퀴즈 정보 불러오기 실패");
    }
  } // 어휘 퀴즈 정보 불러오기

  static Future<void> postWordQuiz(
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
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception('어휘 퀴즈 결과 제출 실패');
    }
  } // 어휘 퀴즈 결과 제출

  static Future<int> getWordQuizResult() async {
    final userId = await getUserId();
    final accessToken = await getAccessToken();
    final url = Uri.parse("$baseUrl/users/$userId/quiz");
    int count = 0;
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      RegExp regex = RegExp('T');
      count = regex.allMatches(body['data']['result']).length;
      return count;
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('$body');
      throw Exception('어휘 퀴즈 맞춘 개수 가져오기 실패');
    }
  } // 어휘 퀴즈 결과(맞춘 개수) 받아오기

  static Future<List<ArticleInfoModel>> getArticles(int category) async {
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
      if (body['data'] != null) {
        for (int i = 0; i < body['data'].length; i++) {
          articleList.add(ArticleInfoModel.fromJson(body['data'][i]));
        }
        return articleList;
      }
      throw Exception('body[\'data\'] 가져오는데 에러 발생..');
    } else if (response.statusCode == 401) {
      await updateToken();
      return await getArticles(category);
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print("articleList() 글 -> ${body['data']}");
      throw Exception("글 목록 가져오기 실패");
    }
  } // 글 목록 가져오기. 1: 인문, 2: 사회, 3: 과학

  static Future<ArticleAndQuiz> getArticleWithExercises(int problemId) async {
    final accessToken = await getAccessToken();
    final url = Uri.parse("$baseUrl/problem/$problemId");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return ArticleAndQuiz.fromJson(body['data']);
    } else if (response.statusCode == 401) {
      await updateToken();
      return getArticleWithExercises(problemId);
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception('글+문제 내용 가져오기 실패');
    }
  } // 문제 내용 (글 본문 + 추가 문제)

  static Future<ReadingResultModel> getProblemResult(int problemId) async {
    final userId = await getUserId();
    final accessToken = await getAccessToken();
    final url = Uri.parse("$baseUrl/problem/$problemId/users/$userId");

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return ReadingResultModel.fromJson(body['data']);
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception('문제 풀이 결과 리턴 실패');
    }
  } // 문제 풀이 결과 가져오기. pid 리턴함

  static Future<List<WordInfoModel>> getDictionarySearch(String word) async {
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
      if (body['data'] != null) {
        for (int i = 0; i < body['data'].length; i++) {
          wordList.add(WordInfoModel.fromJson(body['data'][i]));
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

  static Future<Map<String, dynamic>> postProblemResolved(
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

      return body['data'];
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print(body);
      throw Exception("문제 풀이 결과 보내기 실패");
    }
  } // 문제 풀이: 글 읽고, 문제 푼 결과 서버에 보내기

  static Future<List<dynamic>> getResolvedProblemCount() async {
    final accessToken = await getAccessToken();
    final userId = await getUserId();
    final url = Uri.parse('$baseUrl/users/$userId/statistics');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $accessToken', // access token을 헤더에 추가
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json'
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      return body['data']; // [{'level':상, 'num':2}, ...]
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception('난이도 별 읽은 글 개수 가져오기 실패');
    }
  } // 난이도 별 읽은 글 개수

  static Future<void> updateProblemBookmark(int problemId) async {
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
    } else {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      print('북마크 여부 보내기 problemBookmark() 호출: $body');
      throw Exception("북마크 api 호출 실패");
    }
  } // 글의 북마크 여부 보내기

  static Future<List<ArticleBookmarkModel>> getProblemBookmarks(
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
      return bookmarkList;
    } else if (response.statusCode == 401) {
      await updateToken();
      return await getProblemBookmarks(category);
    } else {
      throw Exception("글 북마크 리스트 api 호출 실패");
    }
  } // 북마크된 글의 리스트 가져오기

  static Future<void> updateWordBookmark(
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
    if (response.statusCode != 200) {
      throw Exception("북마크 api 호출 실패");
    }
  } // 단어 북마크 여부 보내기

  static Future<List<WordBookmarkModel>> getWordBookmarks() async {
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
      return wordBookmarkList;
    } else if (response.statusCode == 401) {
      await updateToken();
      return await getWordBookmarks();
    } else {
      throw Exception("글 북마크 리스트 api 호출 실패");
    }
  } // 북마크된 단어 리스트 가져오기
}
