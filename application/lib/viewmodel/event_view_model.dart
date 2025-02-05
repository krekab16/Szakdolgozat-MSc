import 'package:application/model/event_model.dart';
import 'package:application/model/user_model.dart';
import 'package:flutter/widgets.dart';
import '../service/event_database_service.dart';
import '../service/user_database_service.dart';
import '../utils/text_strings.dart';

class EventViewModel with ChangeNotifier {
  final EventDatabaseService service = EventDatabaseService();
  final UserDatabaseService userService = UserDatabaseService();

  List<String> errorMessages = [];

  Future<void> addFavouriteEvent(UserModel userModel, String eventId) async {
    userModel.favorites?.add(eventId);
    notifyListeners();
  }

  Future<void> removeFavouriteEvent(UserModel userModel, String eventId) async {
    userModel.favorites?.remove(eventId);
    notifyListeners();
  }

  Future<bool> getEventWithFavoriteStatus(UserModel userModel, String eventId) async {
    return userModel.favorites?.contains(eventId) ?? false;
  }

  Future<void> updateEvent(EventModel eventModel) async {
    try {
      await service.updateEvent(eventModel.toDTO());
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      await userService.updateUser(userModel.toDTO());
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
  }

  Future<void> addParticipation(String userId, EventModel eventModel) async {
    try {
      await service.addParticipation(userId, eventModel.toDTO());
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

  Future<void> removeParticipation(String userId, EventModel eventModel) async {
    try {
      await service.removeParticipation(userId, eventModel.toDTO());
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

  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }


}
