import 'package:flutter/material.dart';
import 'package:application/utils/input_box.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/my_button.dart';
import '../utils/password_input_box.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/log_in_screen_view_model.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreen();
}

class _LogInScreen extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final logInViewModel = Provider.of<LogInViewModel>(context);
    var userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          logIn,
          style: Styles.textStyles,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputBox(
                      const Icon(
                        Icons.mail,
                      ),
                      email,
                      (email) => {userModel.email = email},
                      (value) => logInViewModel.validateEmail(value!),
                    ),
                    PasswordInputBox(
                        const Icon(
                          Icons.vpn_key,
                        ),
                        password,
                        (password) => {userModel.password = password},
                        (value) => logInViewModel.validatePassword(value!),
                        passwordVisible,
                        IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: MyButton(logIn, () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          userModel.updateUser(
                              await logInViewModel.login(userModel));
                          if (logInViewModel.errorMessages.isEmpty) {
                            logInViewModel.navigateToHome(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(
                                        errorDialogTitle,
                                        style: Styles.errorText,
                                      ),
                                      content: Text(
                                        logInViewModel.errorMessages.join(" "),
                                        style: Styles.errorText,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(close),
                                        )
                                      ],
                                    ));
                          }
                        }
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
