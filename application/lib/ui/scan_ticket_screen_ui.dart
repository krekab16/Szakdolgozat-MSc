import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/scan_ticket_view_model.dart';

class ScanTicketScreen extends StatefulWidget {
  const ScanTicketScreen({Key? key}) : super(key: key);

  @override
  State<ScanTicketScreen> createState() => _ScanTicketScreenState();
}

class _ScanTicketScreenState extends State<ScanTicketScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ScanTicketViewModel>(context);
    if (!viewModel.isCameraInitialized) {
      viewModel.initializeCamera();
    }
    return Consumer<ScanTicketViewModel>(builder: (context, viewModel, _) {
      if (viewModel.scannedCode != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          bool isValid = await viewModel.validateQrCodeForEvent(
            viewModel.scannedCode!,
            viewModel.currentEvent!.id,
          );
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(isValid ? qrCodeDetected : qrCodeInvalid),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(close),
                ),
              ],
            ),
          );
          viewModel.clearScannedCode();
        });
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.lightBlueColor,
          title: Text(
            scanQrCode,
            style: Styles.textStyles,
          ),
        ),
        body: viewModel.isCameraInitialized
            ? CameraPreview(viewModel.controller!)
            : Center(child: CircularProgressIndicator()),
      );
    });
  }
}
