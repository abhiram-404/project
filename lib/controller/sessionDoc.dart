import 'package:shared_preferences/shared_preferences.dart';

class SessionManagerDoc {
  static final SessionManagerDoc _instance = SessionManagerDoc._internal();

  String? userId;
  String? phone;

  factory SessionManagerDoc() {
    return _instance;
  }

  SessionManagerDoc._internal();

  Future<void> setSessionManager(String userPhone, String userUid) async {
    phone = userPhone;
    userId = userUid;


    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', phone!);
    await prefs.setString('userId', userUid);

  }

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone');
    userId = prefs.getString('userId');
  }

  Future<void> clearSession() async {
    phone = null;
    userId = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  Future<Map<String, String>?> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');
    String? uid = prefs.getString('userId');

    if (phone != null && uid != null) {
      return {
        'phone': phone,
        'userId': uid,
      };
    }
    return null;
  }

  void setUserData(String userId, String phone) {
    this.userId = userId;
    this.phone = phone;
  }

  void clearUserData() {
    userId = null;
    phone = null;
  }

  String? getUserId() => userId;
  String? getPhone() => phone;
}
