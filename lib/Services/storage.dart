import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveAccessToken(String accessToken) async {
  await storage.write(key: 'access_token', value: accessToken);
}

Future<String?> getAccessToken() async {
  final accessToken = await storage.read(key: 'access_token');
  return accessToken;
}

Future<void> saveRefreshToken(String refreshToken) async {
  await storage.write(key: 'refresh_token', value: refreshToken);
}

Future<String?> getRefreshToken() async {
  final refreshToken = await storage.read(key: 'refresh_token');
  return refreshToken;
}

Future<void> saveUserId(String id) async {
  await storage.write(key: 'user_id', value: id);
}

Future<String?> getUserId() async {
  final id = await storage.read(key: 'user_id');
  return id;
}

Future<void> deleteTokenAndId() async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
  await storage.delete(key: 'user_id');
}

Future<bool> isLoggedIn() async {
  if (await getAccessToken() != null && await getUserId() != null)
    return true;
  else
    return false;
}

Future<void> saveProblemId(int id) async {
  await storage.write(key: 'problem_id', value: id.toString());
}

Future<int?> getProblemId() async {
  final id = await storage.read(key: 'problem_id');
  return int.parse(id!);
}

Future<void> saveTargetCode(int id) async {
  await storage.write(key: 'target_code', value: id.toString());
}

Future<int?> getTargetCode() async {
  final id = await storage.read(key: 'target_code');
    return int.parse(id!);
}
