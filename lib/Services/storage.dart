import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> saveAccessToken(String accessToken) async {
  await storage.write(key: 'access_token', value: accessToken);
}

Future<String?> getAccessToken() async {
  final accessToken = await storage.read(key: 'access_token');
  return accessToken;
}

Future<void> saveUserId(String id) async {
  await storage.write(key: 'user_id', value: id);
}

Future<String?> getUserId() async {
  final id = await storage.read(key: 'user_id');
  return id;
}
