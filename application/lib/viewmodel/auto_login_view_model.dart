import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../model/user_dto.dart';
import '../model/user_model.dart';
import '../user_login_singleton.dart';
import '../utils/text_strings.dart';

class AutoLoginViewModel with ChangeNotifier {

  final UserLoginSingleton userLoginSingleton = UserLoginSingleton();
  List<String> errorMessages = [];
  final UserModel userModel = UserModel.createEmpty();

  AutoLoginViewModel() {
    autoLogin(userModel);
  }

  Future<UserModel> autoLogin(UserModel userModel) async {
    try {
      String? token = userLoginSingleton.getRememberedUserToken();
      String? userId = userLoginSingleton.getRememberedUserId();
      String? userJson = userLoginSingleton.getRememberedUserData();
      if (token != null && userJson != null && userId != null) {
        UserDTO userDTO = UserDTO.fromJson(jsonDecode(userJson), userId);
        userModel = UserModel.fromDTO(userDTO);
      }
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    return userModel;
  }

}
