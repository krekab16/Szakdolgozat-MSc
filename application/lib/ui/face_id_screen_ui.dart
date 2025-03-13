import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/image_strings.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/faceid_view_model.dart';
import 'home_screen.dart';

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
              });
              return const HomeScreen();
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
