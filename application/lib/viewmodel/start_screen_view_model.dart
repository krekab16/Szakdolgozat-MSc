import 'package:application/model/user_model.dart';
import 'package:application/utils/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartViewModel with ChangeNotifier {

  UserModel userModel = UserModel.createEmpty();


  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, signUpRoute);
  }

  void navigateToLogIn(BuildContext context) {
    Navigator.pushNamed(context, logInRoute);
  }




  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, homeRoute);
  }



  Future<bool> checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? userId = prefs.getString('user_id');

    if (token != null && userId != null) {

      print("Automatikus bejelentkezés sikeres, felhasználó: ${userModel.name}");
      return true;


    } else {
      print("Nincs érvényes token a bejelentkezéshez.");
      return false;
    }
  }



}


