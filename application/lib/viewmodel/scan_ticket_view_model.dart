import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/event_model.dart';
import '../service/ticket_database_service.dart';
import '../utils/text_strings.dart';

class ScanTicketViewModel with ChangeNotifier {
  CameraController? controller;
  late BarcodeScanner barcodeScanner;
  bool isCameraInitialized = false;
  bool isDetecting = false;
  String? scannedCode;
  EventModel? currentEvent;
  List<String> errorMessages = [];
  final TicketDatabaseService service = TicketDatabaseService();

  ScanTicketViewModel() {
    barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
  }

  Future<void> initializeCamera() async {
    PermissionStatus permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        CameraDescription camera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
        controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
        try {
          await controller!.initialize();
          isCameraInitialized = true;
          notifyListeners();
          startImageStream();
        } catch (e) {
          if (e.toString().isNotEmpty) {
            errorMessages = [e.toString()];
          } else {
            errorMessages = [standardErrorMessage];
          }
        }
      }
    }
  }

  Future<void> startImageStream() async {
    controller?.startImageStream((CameraImage cameraImage) async {
      if (isDetecting) return;
      isDetecting = true;
      try {
        final WriteBuffer allBytes = WriteBuffer();
        for (final Plane plane in cameraImage.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final bytes = allBytes.done().buffer.asUint8List();
        final Size imageSize = Size(
          cameraImage.width.toDouble(),
          cameraImage.height.toDouble(),
        );
        final rotation = InputImageRotationValue.fromRawValue(
          controller!.description.sensorOrientation,
        ) ?? InputImageRotation.rotation0deg;
        final inputImageFormat = InputImageFormat.nv21;
        final inputImage = InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: imageSize,
            rotation: rotation,
            format: inputImageFormat,
            bytesPerRow: cameraImage.planes.first.bytesPerRow,
          ),
        );
        final barcodes = await barcodeScanner.processImage(inputImage);
        if (barcodes.isNotEmpty) {
          scannedCode = barcodes.first.displayValue;
          notifyListeners();
          await controller!.stopImageStream();
          if (scannedCode != null && currentEvent != null) {
            await validateQrCodeForEvent(scannedCode!, currentEvent!.id);
          }
        }
      } catch (e) {
        if (e.toString().isNotEmpty) {
          errorMessages = [e.toString()];
        } else {
          errorMessages = [standardErrorMessage];
        }
      } finally {
        isDetecting = false;
      }
    });
  }

  Future<bool> validateQrCodeForEvent(String qrCode, String eventId) async {
    try {
      bool isValid = await service.validateQrCodeForEvent(qrCode, eventId);
      errorMessages = [];
      return isValid;
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
    return false;
  }

  void clearScannedCode() {
    scannedCode = null;
    notifyListeners();
  }

}
