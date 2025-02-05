import 'package:application/viewmodel/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/my_button.dart';
import '../utils/password_input_box.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    ProfileViewModel profileViewModel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          profile,
          style: Styles.textStyles,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: fullName),
                enabled: true,
                controller: TextEditingController(
                  text: profileViewModel.getProfileName(),
                ),
                onChanged: (value) =>
                    profileViewModel.setProfileName(value),
                validator: (value) => profileViewModel.validateName(value!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: userName),
                enabled: true,
                controller: TextEditingController(
                  text: profileViewModel.getProfileUserName(),
                ),
                onChanged: (value) =>
                    profileViewModel.setProfileUserName(value),
                validator: (value) => profileViewModel.validateUserName(value!),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        labelText: password,
                      ),
                      controller: TextEditingController(
                        text: profileViewModel.getProfilePassword(),
                      ),
                      onChanged: (value) => profileViewModel.setProfilePassword(value),
                      validator: (value) => profileViewModel.validatePassword(value!),
                    ),
                  ),
                  IconButton(
                    icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: MyButton(save, () async {
                  if (_formKey.currentState!.validate()) {
                    if (profileViewModel.errorMessages.isEmpty) {
                      await profileViewModel.updateUser();
                      Fluttertoast.showToast(msg: successfulUpdateMessage);
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(
                                  errorDialogTitle,
                                  style: Styles.errorText,
                                ),
                                content: Text(
                                  profileViewModel.errorMessages.join(" "),
                                  style: Styles.errorText,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(close),
                                  )
                                ],
                              ));
                    }
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
