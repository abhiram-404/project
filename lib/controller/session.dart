import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  String? userId;
  String? email;
  String? googleDisplayName;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> setSessionManager(String userEmail, String userUid, {String? googleName}) async {
    email = userEmail;
    userId = userUid;
    googleDisplayName = googleName;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', userEmail);
    await prefs.setString('userId', userUid);

    if (googleName != null) {
      await prefs.setString('googleDisplayName', googleName);
    }
  }

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    userId = prefs.getString('userId');
    googleDisplayName = prefs.getString('googleDisplayName');
  }

  Future<void> clearSession() async {
    email = null;
    userId = null;
    googleDisplayName = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  Future<Map<String, String>?> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? uid = prefs.getString('userId');
    String? googleName = prefs.getString('googleDisplayName');

    if (email != null && uid != null) {
      return {
        'email': email,
        'userId': uid,
        'googleDisplayName': googleName ?? '',
      };
    }
    return null;
  }

  void setUserData(String userId, String email) {
    this.userId = userId;
    this.email = email;
  }

  void clearUserData() {
    userId = null;
    email = null;
  }

  String? getUserId() => userId;
  String? getEmail() => email;
  String? getGoogleDisplayName() => googleDisplayName;
}
