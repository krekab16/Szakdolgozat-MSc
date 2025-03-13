import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import '../model/user_dto.dart';
import '../model/user_model.dart';
import '../user_login_singleton.dart';
import '../utils/route_constants.dart';
import '../utils/text_strings.dart';

class FaceIdViewModel with ChangeNotifier {
  final localAuthentication = LocalAuthentication();
  bool isUserAuthorized = false;
  List<String> errorMessages = [];
  final UserModel userModel = UserModel.createEmpty();
  final UserLoginSingleton userLoginSingleton = UserLoginSingleton();


  FaceIdViewModel() {
    authenticateUser(userModel);
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, homeRoute);
  }



  Future<UserModel> authenticateUser(UserModel userModel) async {
    bool isAuthorized = false;
    try {
      isAuthorized = await localAuthentication.authenticate(
        localizedReason: faceIdAuthentication,
      );
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    if (isAuthorized) {
      isUserAuthorized = true;
      String? userId = userLoginSingleton.getRememberedUserId();
      String? userJson = userLoginSingleton.getRememberedUserData();
      if ( userJson != null && userId != null) {
        UserDTO userDTO = UserDTO.fromJson(jsonDecode(userJson), userId);
        userModel = UserModel.fromDTO(userDTO);
      }
    } else{
      isUserAuthorized = false;
    }
    return userModel;
  }
}