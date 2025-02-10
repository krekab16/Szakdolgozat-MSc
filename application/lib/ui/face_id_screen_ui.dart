import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/image_strings.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () async {
                  await faceIdViewModel.authenticateUser();
                  if (faceIdViewModel.isUserAuthorized) {
                    faceIdViewModel.navigateToHome(context);
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
                },
                child: Image.asset(
                  faceIdImage,
                  height: 160,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
