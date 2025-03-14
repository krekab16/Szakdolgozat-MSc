import 'package:flutter/cupertino.dart';
import '../model/user_model.dart';
import '../service/user_database_service.dart';
import '../user_login_singleton.dart';
import '../utils/text_strings.dart';

class SplashScreenViewModel with ChangeNotifier {

  final UserLoginSingleton userLoginSingleton = UserLoginSingleton();
  List<String> errorMessages = [];
  final UserModel userModel = UserModel.createEmpty();
  final UserDatabaseService service = UserDatabaseService();


  Future<bool> checkAutoLogin() async {
    try {
      errorMessages = [];
      final rememberMe = userLoginSingleton.getRememberMe() ?? false;
      final tokenValid = await service.hasValidRefreshToken();
      if (rememberMe && tokenValid) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
      return false;
    }
  }

}
