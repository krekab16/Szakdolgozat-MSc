import 'package:application/utils/route_constants.dart';
import 'package:flutter/material.dart';

class StartViewModel with ChangeNotifier {
  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, signUpRoute);
  }

  void navigateToLogIn(BuildContext context) {
    Navigator.pushNamed(context, logInRoute);
  }
}
