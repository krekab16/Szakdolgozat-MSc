import 'package:flutter/material.dart';
import '../viewmodel//start_screen_view_model.dart';
import '../utils/colors.dart';
import '../utils/image_strings.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../utils/my_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreen createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {
  final viewModel = StartViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Image(
                        image: AssetImage(welcomeImage),
                        height: 160,
                      ),
                      Text(
                        appName,
                        style: Styles.welcomeApplicationNameStyle,
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        welcomeTitle,
                        style: Styles.welcomeTitleStyles,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        welcomeSubTitle,
                        style: Styles.welcomeSubTitleStyles,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: MyButton(
                          signUp, () => viewModel.navigateToSignUp(context)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: MyButton(
                          logIn, () => viewModel.navigateToLogIn(context)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
