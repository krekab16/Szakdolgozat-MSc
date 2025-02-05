import 'package:application/model/user_model.dart';
import 'package:flutter/material.dart';
import '../model/user_dto.dart';
import '../service/user_database_service.dart';
import '../utils/text_strings.dart';

class ProfileViewModel with ChangeNotifier {
  final UserDatabaseService service = UserDatabaseService();

  UserModel userProfile = UserModel.createEmpty();

  List<String> errorMessages = [];

  String getProfileName() {
    return userProfile.name;
  }

  String getProfileUserName() {
    return userProfile.username;
  }

  String getProfilePassword() {
    return userProfile.password;
  }

  void setProfileName(String name) {
    userProfile.name = name;
  }

  void setProfileUserName(String username) {
    userProfile.username = username;
  }

  void setProfilePassword(String password) {
    userProfile.password = password;
  }

  void setUserModel(UserDTO user) {
    userProfile = UserModel.fromDTO(user);
    notifyListeners();
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      final userProfile = await service.getUserProfile(userId);
      setUserModel(userProfile);
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
  }

  Future<void> updateUser() async {
    try {
      await service.updateUserProfile(userProfile.toDTO());
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return mustEnterNameErrorMessage;
    }
    return null;
  }

  String? validateUserName(String value) {
    if (value.isEmpty) {
      return mustEnterUsernameErrorMessage;
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
