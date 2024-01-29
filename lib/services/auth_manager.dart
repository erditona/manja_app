import 'package:flutter/material.dart';
import 'package:manja_app/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static const String loginStatusKey = 'loginStatusKey';
  static const String loginTimeKey = 'loginTimeKey';
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('loginStatusKey') ?? false;
    String? loginTimeString = prefs.getString('loginTimeKey');
    if (isLoggedIn && loginTimeString != null) {
      try {
        DateTime loginTime = DateTime.parse(loginTimeString);
        final Duration timeDifference = DateTime.now().difference(loginTime);
        // Set maximum durasi untuk validasi login di bawah ini
        const Duration maxDuration = Duration(hours: 4);
        if (timeDifference > maxDuration) {
          await logout();
          return false;
        }
        return true;
      } catch (e) {
        debugPrint('Error parsing DateTime: $e');
        await logout();
        return false;
      }
    }
    return false;
  }

  static Future<void> login(String email, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loginStatusKey', true);
    prefs.setString('loginTimeKey', DateTime.now().toString());
    prefs.setString('email', email);
    prefs.setString('token', token);
    print("token: $token");
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loginStatusKey');
    prefs.remove('loginTimeKey');
    prefs.remove('email');
    prefs.remove('token');
    prefs.remove('nama_lengkap');
    prefs.remove('phonenumber');
  }

  static Future<void> getuser(Profile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nama_lengkap', profile.namalengkap);
    prefs.setString('phonenumber', profile.phonenumber);
    prefs.setString('email', profile.email);
  }
}
