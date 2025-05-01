import 'dart:core';
import 'package:application/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/user_database_service.dart';
import '../ui/home_screen.dart';
import '../utils/text_strings.dart';
import 'home_view_model.dart';

class SignUpViewModel with ChangeNotifier {
  final UserDatabaseService service = UserDatabaseService();

  List<String> errorMessages = [];


  void navigateToHome(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) =>
          HomeViewModel()
            ..fetchRecommendedEvents(userId),
          child: const HomeScreen(),
        ),
      ),
    );
  }

  Future<String> register(UserModel userModel) async {
    UserModel newUser = UserModel.createEmpty();
    try {
     newUser = UserModel.fromDTO(await service.addUserToDatabase(userModel.toDTO()));
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
    return newUser.id;
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

  String? validateEmail(String value) {
    if (!value.contains("@") && value.isNotEmpty) {
      return wrongEmailErrorMessage;
    } else if (value.isEmpty) {
      return mustEnterEmailErrorMessage;
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 6 && value.isNotEmpty) {
      return validatePasswordErrorMessage;
    } else if (value.isEmpty) {
      return mustEnterPasswordErrorMessage;
    }
    return null;
  }
}
