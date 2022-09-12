import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{
  
  static SharedPreferences? _preferences;
  static const _keyEmail = 'email';
  static const _keyToken = 'token';
  static const _keyUserImage = 'userImage';
  static const _keyDarkMode = 'darkMode';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUserEmail(String email) async{
    await _preferences?.setString(_keyEmail, email);
  }

  static String? getEmail() => _preferences?.getString(_keyEmail);

   static Future setUserImage(String image) async{
    await _preferences?.setString(_keyUserImage, image);
  }

  static String? getUserImage() => _preferences?.getString(_keyUserImage);

  static Future setDarkMode(bool darkMode) async{
    await _preferences?.setBool(_keyDarkMode, darkMode);
  }

  static bool? getDarkMode() => _preferences?.getBool(_keyDarkMode);

   static Future setUserToken(String token) async{
    await _preferences?.setString(_keyToken, token);
  }

  static String? getToken() => _preferences?.getString(_keyToken);
  
  static void clear(){_preferences?.clear();}
  }