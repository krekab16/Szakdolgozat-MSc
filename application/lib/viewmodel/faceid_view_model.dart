import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import '../utils/route_constants.dart';
import '../utils/text_strings.dart';

class FaceIdViewModel with ChangeNotifier {
  final localAuthentication = LocalAuthentication();
  bool isUserAuthorized = false;
  List<String> errorMessages = [];

  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, homeRoute);
  }

  Future<void> authenticateUser() async {
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
    }
    notifyListeners();
  }
}