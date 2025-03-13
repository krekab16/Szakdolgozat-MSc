import 'package:application/ui/face_id_screen_ui.dart';
import 'package:application/ui/start_screen_ui.dart';
import 'package:application/viewmodel/auto_login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import 'home_screen.dart';

class AutoLoginScreen extends StatefulWidget {
  const AutoLoginScreen({Key? key}) : super(key: key);


  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreen();
}

class _AutoLoginScreen extends State<AutoLoginScreen> {

  @override
  Widget build(BuildContext context) {
    final autoLoginViewModel = Provider.of<AutoLoginViewModel>(context);
    var userModel = Provider.of<UserModel>(context, listen: false);
    return FutureBuilder<UserModel>(
      future: autoLoginViewModel.autoLogin(userModel),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              userModel.updateUser(snapshot.data!);
            });
          return const HomeScreen();
        } else {
          return const StartScreen();
        }
      },
    );
  }

}
