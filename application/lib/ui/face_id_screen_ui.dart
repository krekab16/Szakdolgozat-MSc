import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/faceid_view_model.dart';

class FaceIdScreen extends StatefulWidget {
  const FaceIdScreen({Key? key}) : super(key: key);

  @override
  _FaceIdScreenState createState() => _FaceIdScreenState();
}

class _FaceIdScreenState extends State<FaceIdScreen> {

  @override
  Widget build(BuildContext context) {
    final faceIdViewModel = Provider.of<FaceIdViewModel>(context);
    var userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          logInWithFaceID,
          style: Styles.textStyles,
        ),
      ),
      body: Center(
        child: FutureBuilder<UserModel>(
          future: faceIdViewModel.authenticateUser(userModel),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                userModel.updateUser(snapshot.data!);
                faceIdViewModel.navigateToHome(context);
              });
              if (faceIdViewModel.errorMessages.isEmpty) {
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
                      faceIdViewModel.errorMessages.join(" "),
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
            }
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                faceIdViewModel.navigateToLogIn(context);
              });
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
