import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../service/user_database_service.dart';
import '../user_login_singleton.dart';
import '../utils/route_constants.dart';
import '../utils/text_strings.dart';

class LogInViewModel with ChangeNotifier {
  final UserDatabaseService service = UserDatabaseService();
  List<String> errorMessages = [];
  bool rememberMe = false;
  final UserLoginSingleton userLoginSingleton = UserLoginSingleton();


  Future<UserModel> login(UserModel userModel) async {
    UserModel newUser = UserModel.createEmpty();
    try {
      newUser = UserModel.fromDTO(await service.logInUser(userModel.toDTO()));
      errorMessages = [];
      String? token = await service.getAuthToken();
      if (rememberMe) {
        UserLoginSingleton().setRememberedUserToken(token!);
        UserLoginSingleton().setRememberedUserId(newUser.id);
        UserLoginSingleton().setRememberedUserData(newUser);
        UserLoginSingleton().setRememberMe(rememberMe);
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
