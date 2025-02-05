import 'package:application/utils/input_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/my_button.dart';
import '../utils/password_input_box.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/sign_up_screen_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final signUpViewModel = Provider.of<SignUpViewModel>(context);
    final userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          signUp,
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
                  children: <Widget>[
                    InputBox(
                      const Icon(
                        Icons.account_circle,
                      ),
                      fullName,
                      (name) => {userModel.name = name},
                      (value) => signUpViewModel.validateName(value!),
                    ),
                    InputBox(
                      const Icon(
                        Icons.account_circle,
                      ),
                      userName,
                      (userName) => {userModel.username = userName},
                      (value) => signUpViewModel.validateUserName(value!),
                    ),
                    InputBox(
                      const Icon(
                        Icons.mail,
                      ),
                      email,
                      (email) => {userModel.email = email},
                      (value) => signUpViewModel.validateEmail(value!),
                    ),
                    PasswordInputBox(
                        const Icon(
                          Icons.vpn_key,
                        ),
                        password,
                            (password) => {userModel.password = password},
                            (value) => signUpViewModel.validatePassword(value!),
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
                    Text(
                      eventsChechBox,
                      style: Styles.textStyles,
                    ),
                    RadioListTile(
                      title: Text(radioTitleYes),
                      value: true,
                      groupValue: userModel.isOrganizer,
                      onChanged: (value) {
                        userModel.updateOrganiserState(value ?? false);
                      },
                    ),
                    RadioListTile(
                      title: Text(radioTitleNo),
                      value: false,
                      groupValue: userModel.isOrganizer,
                      onChanged: (value) {
                        userModel.updateOrganiserState(value ?? false);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: MyButton(signUp, () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          userModel.id =
                              await signUpViewModel.register(userModel);
                          if (signUpViewModel.errorMessages.isEmpty) {
                            signUpViewModel.navigateToHomeScreen(context);
                          } else {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(
                                        errorDialogTitle,
                                        style: Styles.errorText,
                                      ),
                                      content: Text(
                                        signUpViewModel.errorMessages.join(" "),
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
