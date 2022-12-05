import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user.dart';

class SharedPrefs {
  static const String _userKey = "_kUser";

  static Future<User?> getStoredUser() async {
    var sp = await SharedPreferences.getInstance();
    var json = sp.getString(_userKey);
    return (json == "" || json == null)
        ? null
        : User.fromJson(jsonDecode(json));
  }

  static Future setStoredUser(User? user) async {
    var sp = await SharedPreferences.getInstance();
    if (user == null) {
      sp.remove(_userKey);
    } else {
      await sp.setString(
        _userKey,
        jsonEncode(user.toJson()),
      );
    }
  }

  static Future<UserFull?> getStoredUserFull() async {
    var sp = await SharedPreferences.getInstance();
    var json = sp.getString(_userKey);
    return (json == "" || json == null)
        ? null
        : UserFull.fromJson(jsonDecode(json));
  }

  static Future setStoredUserFull(UserFull? user) async {
    var sp = await SharedPreferences.getInstance();
    if (user == null) {
      sp.remove(_userKey);
    } else {
      await sp.setString(
        _userKey,
        jsonEncode(user.toJson()),
      );
    }
  }
}
