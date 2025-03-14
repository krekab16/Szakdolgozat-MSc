import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/user_model.dart';

class MySharedPreference {

  static SharedPreferences? prefs;
  MySharedPreference._();
  static final MySharedPreference instance = MySharedPreference._();

  factory MySharedPreference() {
    return instance;
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? getToken() {
    return prefs?.getString('auth_token');
  }

  String? getUserId() {
    return prefs?.getString('user_id');
  }

  String? getUserData() {
    return prefs?.getString('user_data');
  }

  bool? getRememberMe(){
    return prefs?.getBool('remember_me') ?? false;
  }

  Future<void> setToken(String token) async {
    await prefs?.setString('auth_token', token);
  }

  Future<void> setUserId(String userId) async {
    await prefs?.setString('user_id', userId);
  }

  Future<void> setUserData(UserModel userModel) async {
    await prefs?.setString('user_data', jsonEncode(userModel.toDTO().toJson()));
  }

  Future<void> setRememberMe(bool value) async {
    await prefs?.setBool('remember_me', value);
  }

  Future<void> deleteSharedPreferences() async {
    await prefs?.clear();
  }

}