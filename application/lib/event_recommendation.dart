import 'dart:io';
import 'package:application/utils/text_strings.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class EventRecommendation {
  Interpreter? interpreter;
  List<String> labels = [];
  Map<String, String> labelToEventCategory = {};
  List<String> errorMessages = [];

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model.tflite');
      await _loadLabels();
      initializeLabelMapping();
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
  }

  Future<void> _loadLabels() async {
    final rawLabels = await rootBundle.loadString('assets/labels.txt');
    labels = rawLabels.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
  }

  void initializeLabelMapping() {
    labelToEventCategory = {
      'baseball': 'Sport',
      'basketball': 'Sport',
      'tennis ball': 'Sport',
      'football helmet': 'Sport',
      'soccer ball': 'Sport',
      'rugby ball': 'Sport',
      'golf ball': 'Sport',
      'golfcart': 'Sport',
      'sports car': 'Sport',
      'snowmobile': 'Sport',
      'volleyball': 'Sport',
      'swimming trunks': 'Sport',
      'accordion': 'Music',
      'acoustic guitar': 'Music',
      'bassoon': 'Music',
      'cello': 'Music',
      'drum': 'Music',
      'drumstick': 'Music',
      'electric guitar': 'Music',
      'French horn': 'Music',
      'harmonica': 'Music',
      'harp': 'Music',
      'marimba': 'Music',
      'microphone': 'Music',
      'organ': 'Music',
      'piano': 'Music',
      'saxophone': 'Music',
      'trombone': 'Music',
      'violin': 'Music',
      'bathtub': 'Wellness',
      'beach wagon': 'Wellness',
      'coffee mug': 'Wellness',
      'towel': 'Wellness',
      'pajama': 'Wellness',
      'pillow': 'Wellness',
      'yoga mat': 'Wellness',
      'massage': 'Wellness',
      'painting brush': 'Art',
      'easel': 'Art',
      'palette': 'Art',
      'canvas': 'Art',
      'sculpture': 'Art',
      'theater curtain': 'Art',
      'musical instruments': 'Art',
      'art supplies': 'Art',
      'airplane': 'Technology',
      'airliner': 'Technology',
      'laptop': 'Technology',
      'mobile phone': 'Technology',
      'microwave': 'Technology',
      'printer': 'Technology',
      'remote control': 'Technology',
      'robot': 'Technology',
      'computer': 'Technology',
      'digital camera': 'Technology',
      'telescope': 'Technology',
      'radio': 'Technology',
      'blender': 'Technology',
      'abaya': 'Fashion',
      'cardigan': 'Fashion',
      'bikini': 'Fashion',
      'boots': 'Fashion',
      'dress': 'Fashion',
      'gloves': 'Fashion',
      'hat': 'Fashion',
      'jacket': 'Fashion',
      'scarf': 'Fashion',
      'sunglasses': 'Fashion',
      'sweater': 'Fashion',
      'pants': 'Fashion',
      'shirt': 'Fashion',
      'shoes': 'Fashion',
      'backpack': 'Family',
      'baby stroller': 'Family',
      'teddy bear': 'Family',
      'craddle': 'Family',
      'highchair': 'Family',
      'crib': 'Family',
      'kitchen supplies': 'Family',
      'sofa': 'Family',
      'palace': 'Family',
      'baby bottle': 'Family',
      'pet supplies': 'Family',
      'guacamole': 'Food & Drink',
      'consomme': 'Food & Drink',
      'hot pot': 'Food & Drink',
      'trifle': 'Food & Drink',
      'ice cream': 'Food & Drink',
      'ice lolly': 'Food & Drink',
      'French loaf': 'Food & Drink',
      'bagel': 'Food & Drink',
      'pretzel': 'Food & Drink',
      'cheeseburger': 'Food & Drink',
      'hotdog': 'Food & Drink',
      'mashed potato': 'Food & Drink',
      'head cabbage': 'Food & Drink',
      'broccoli': 'Food & Drink',
      'cauliflower': 'Food & Drink',
      'zucchini': 'Food & Drink',
      'spaghetti squash': 'Food & Drink',
      'acorn squash': 'Food & Drink',
      'butternut squash': 'Food & Drink',
      'cucumber': 'Food & Drink',
      'artichoke': 'Food & Drink',
      'bell pepper': 'Food & Drink',
      'cardoon': 'Food & Drink',
      'mushroom': 'Food & Drink',
      'Granny Smith': 'Food & Drink',
      'strawberry': 'Food & Drink',
      'orange': 'Food & Drink',
      'lemon': 'Food & Drink',
      'fig': 'Food & Drink',
      'pineapple': 'Food & Drink',
      'banana': 'Food & Drink',
      'jackfruit': 'Food & Drink',
      'custard apple': 'Food & Drink',
      'pomegranate': 'Food & Drink',
      'hay': 'Food & Drink',
      'carbonara': 'Food & Drink',
      'chocolate sauce': 'Food & Drink',
      'dough': 'Food & Drink',
      'meat loaf': 'Food & Drink',
      'pizza': 'Food & Drink',
      'potpie': 'Food & Drink',
      'burrito': 'Food & Drink',
      'red wine': 'Food & Drink',
      'espresso': 'Food & Drink',
      'cup': 'Food & Drink',
      'eggnog': 'Food & Drink',
    };
  }

  Future<String> recommendEvent(File imageFile) async {
    var image = await preprocessImage(imageFile);
    var input = image.reshape([1, 224, 224, 3]);
    var output = List.filled(1001, 0.0).reshape([1, 1001]);
    interpreter?.run(input, output);
    var outputList = List<double>.from(output[0]);
    var maxIndex = outputList.indexOf(outputList.reduce((a, b) => a > b ? a : b));
    var label = labels[maxIndex];
    return getEventRecommendation(label);
  }

  Future<List<double>> preprocessImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);
    final resizedImage = img.copyResize(originalImage!, width: 224, height: 224);
    List<double> imageAsList = [];
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixelSafe(x, y);
        final r = (pixel.r - 127.5) / 127.5;
        final g = (pixel.g - 127.5) / 127.5;
        final b = (pixel.b - 127.5) / 127.5;
        imageAsList.addAll([r, g, b]);
      }
    }
    return imageAsList;
  }

  String getEventRecommendation(String label) {
    return labelToEventCategory[label] ?? 'Other';
  }

}
