import 'package:application/ui/face_id_screen_ui.dart';
import 'package:application/ui/start_screen_ui.dart';
import 'package:application/viewmodel/splash_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../utils/styles.dart';
import '../utils/text_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final splashScreenViewModel = Provider.of<SplashScreenViewModel>(context);

    return FutureBuilder<bool>(
      future: splashScreenViewModel.checkAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return snapshot.data == true ? FaceIdScreen() : StartScreen();
        }
        if (splashScreenViewModel.errorMessages.isEmpty) {
          Fluttertoast.showToast(
              msg: successfulRemoveFromParticipationMessage);
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(
                errorDialogTitle,
                style: Styles.errorText,
              ),
              content: Text(
                splashScreenViewModel.errorMessages.join(" "),
                style: Styles.errorText,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(close),
                )
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

}
