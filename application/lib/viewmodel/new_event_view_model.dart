import 'package:flutter/material.dart';
import 'package:application/model/event_model.dart';
import 'package:flutter/foundation.dart';
import '../load_generated_text.dart';
import '../service/event_database_service.dart';
import '../utils/text_strings.dart';
import 'dart:io';
import '../event_recommendation.dart';


class NewEventScreenViewModel with ChangeNotifier {
  final EventModel _event = EventModel.createEmpty();

  final EventDatabaseService service = EventDatabaseService();

  final EventRecommendation eventRecommendation = EventRecommendation();

  List<String> errorMessages = [];

  NewEventScreenViewModel() {
    loadEvents();
    eventRecommendation.loadModel();
  }

  void setName(String name) {
    _event.name = name;
    notifyListeners();
  }

  void setAddress(String address) {
    _event.address = address;
    notifyListeners();
  }

  void setCategory(String category) {
    _event.category = category;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _event.date = date;
    notifyListeners();
  }

  void setStuffLimit(int stuffLimit) {
    _event.stuffLimit = stuffLimit;
    notifyListeners();
  }

  void setImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return;
    }
    _event.image = imagePath;
    notifyListeners();
    final imageFile = File(imagePath);
    try {
      var recommendedCategory = await eventRecommendation.recommendEvent(imageFile);
      setCategory(recommendedCategory);
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
  }

  void setDescription(String description) {
    if (description.isEmpty) {
      final fuzzyDescription = getDescriptionForEvent(_event.name);
      if (fuzzyDescription != null) {
        _event.description = fuzzyDescription;
      } else {
        _event.description = "";
      }
    } else {
      _event.description = description;
    }
    notifyListeners();
  }

  Future<void> addNewEvent(String userId, File imageFile) async {
    try {
      await service.addEventToDatabase(userId, _event.toDTO(), imageFile);
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return mustEnterEventNameErrorMessage;
    }
    return null;
  }

  String? validateStuffLimit(String value) {
    if (value.isEmpty) {
      return mustEnterStuffLimitErrorMessage;
    }
    int? limit = int.tryParse(value);
    if (limit == null) {
      return onlyNumbersAllowedErrorMessage;
    } else if (limit < 0) {
      return negativeNumbersNotAllowedErrorMessage;
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return mustEnterAddressErrorMessage;
    }
    return null;
  }

  String? validateImage(List<dynamic>? value) {
    if (value == null || value.isEmpty) {
      return mustAddImageErrorMessage;
    }
    return null;
  }

  String? validateDate(String value) {
    if (value.isEmpty) {
      return mustEnderDateErrorMessage;
    }
    return null;
  }

  String? validateDescription(String? value) {
    if ((value == null || value.isEmpty) && (_event.description.isEmpty)) {
      return mustEnterDescriptionErrorMessage;
    }
    return null;
  }

}
