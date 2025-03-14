import 'package:application/model/user_model.dart';
import 'package:application/my_shared_preference.dart';

class UserLoginSingleton {

  String? getToken = MySharedPreference().getToken();
  String? getUserData = MySharedPreference().getUserData();
  String? getUserId = MySharedPreference().getUserId();
  bool? getIsRememberMe = MySharedPreference().getRememberMe();


  void setRememberedUserToken(String newToken) {
    MySharedPreference().setToken(newToken);
  }

  void setRememberedUserId(String newId) {
    MySharedPreference().setUserId(newId);
  }

  void setRememberedUserData(UserModel newUserData) {
    MySharedPreference().setUserData(newUserData);
  }

  void setRememberMe(bool isRememberMe) {
    MySharedPreference().setRememberMe(isRememberMe);
  }

  void deleteSharedPreferences(){
    MySharedPreference().deleteSharedPreferences();
  }

  String? getRememberedUserToken() {
    return getToken;
  }

  String? getRememberedUserId() {
    return getUserId;
  }

  String? getRememberedUserData() {
    return getUserData;
  }

  bool? getRememberMe() {
    return getIsRememberMe;
  }

}


