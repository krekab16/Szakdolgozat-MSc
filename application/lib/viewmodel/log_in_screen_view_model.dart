import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../service/user_database_service.dart';
import '../utils/route_constants.dart';
import '../utils/text_strings.dart';

class LogInViewModel with ChangeNotifier {
  final UserDatabaseService service = UserDatabaseService();
  List<String> errorMessages = [];
  bool rememberMe = false;

  Future<UserModel> login(UserModel userModel) async {
    UserModel newUser = UserModel.createEmpty();
    try {
      newUser = UserModel.fromDTO(await service.logInUser(userModel.toDTO()));
      errorMessages = [];

      String? token = await service.getAuthToken();
      String userId = newUser.id;

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token!);
        await prefs.setString('user_id', userId);
        print("Token mentve: $token");
        print("UserId mentve: $userId");
      }
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
    return newUser;
  }


  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, homeRoute);
  }

  void navigateToFaceId(BuildContext context) {
    Navigator.pushNamed(context, faceIdRoute);
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return mustEnterEmailErrorMessage;
    } else if (!value.contains("@")) {
      return wrongEmailErrorMessage;
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return mustEnterPasswordErrorMessage;
    } else if (value.length < 6) {
      return validatePasswordErrorMessage;
    }
    return null;
  }


}
