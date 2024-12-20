import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // Singleton instance
  static final SessionManager _instance = SessionManager._internal();
  String username = 'Guest';
  String fullName = 'Full Name';

  // Factory constructor to return the same instance
  factory SessionManager() {
    return _instance;
  }

  // Private constructor
  SessionManager._internal();

  // Load user data once
  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? 'Guest';
    fullName = prefs.getString('fullname') ?? 'Full Name';
  }

  // You can also add a method to save session data
  Future<void> saveUserData(String username, String fullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('fullname', fullName);
  }
}
