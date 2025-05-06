import 'dart:convert';
import 'package:application/utils/text_strings.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:string_similarity/string_similarity.dart';

Map<String, String> eventDescriptions = {};

List<String> errorMessages = [];

Future<void> loadEvents() async {
  try {
    final String response = await rootBundle.loadString('assets/generated_text/generated_descriptions.json');
    final data = json.decode(response);

    data.forEach((key, value) {
      eventDescriptions[key] = value;
    });
  } catch (e) {
    if (e.toString().isNotEmpty) {
      errorMessages = [e.toString()];
    } else {
      errorMessages = [standardErrorMessage];
    }
  }
}

String? getDescriptionForEvent(String eventName) {
  if (eventDescriptions.isEmpty) {
    return null;
  }
  var bestMatch = StringSimilarity.findBestMatch(eventName, eventDescriptions.keys.toList());
  if (bestMatch.bestMatch.rating! < 0.4) {
    return null;
  }
  final bestMatchName = bestMatch.bestMatch.target;
  return eventDescriptions[bestMatchName];
}
