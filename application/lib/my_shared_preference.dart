import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/user_model.dart';

class MySharedPreference {

  static SharedPreferences? _prefs;
  MySharedPreference._();
  static final MySharedPreference _instance = MySharedPreference._();

  factory MySharedPreference() {
    return _instance;
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getToken() {
    return _prefs?.getString('auth_token');
  }

  String? getUserId() {
    return _prefs?.getString('user_id');
  }

  String? getUserData() {
    return _prefs?.getString('user_data');
  }


  Future<void> setToken(String token) async {
    await _prefs?.setString('auth_token', token);
    print("Token elmentve: ${MySharedPreference().getToken()}");
  }

  Future<void> setUserId(String userId) async {
    await _prefs?.setString('user_id', userId);
    print("UserID elmentve: ${MySharedPreference().getUserId()}");

  }

  Future<void> setUserData(UserModel userModel) async {
    await _prefs?.setString('user_data', jsonEncode(userModel.toDTO().toJson()));
    print("User elmentve: ${MySharedPreference().getUserData()}");
  }

}