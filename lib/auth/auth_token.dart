import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: 'authToken', value: token);
    } catch (e) {
      // Handle any errors here
      print("Error saving token: $e");
    }
  }
}
