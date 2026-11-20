import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String username = 'Gabriel';
  static const String password = '124240064';

  static get currentUser => null;

  // Proses login
  static Future<bool> login(String inputUsername, String inputPassword) async {
    if (inputUsername == username && inputPassword == password) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', true);

      return true;
    }

    return false;
  }

  // Memeriksa status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
  }
}
