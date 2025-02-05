import 'package:application/model/event_model.dart';
import 'package:flutter/material.dart';
import '../model/event_dto.dart';
import '../model/favourite_event_model.dart';
import '../service/event_database_service.dart';
import '../utils/text_strings.dart';

class FavouriteEventViewModel with ChangeNotifier {
  FavouriteEventModel favouriteEventModel = FavouriteEventModel();

  final EventDatabaseService service = EventDatabaseService();

  List<String> errorMessages = [];

  Future<void> fetchFavouriteEvent(String userId) async {
    try {
      final List<EventDTO> eventDTO = await service.getFavouriteEvent(userId);
      final List<EventModel> eventModel =
          eventDTO.map((dto) => EventModel.fromDTO(dto)).toList();
      favouriteEventModel.events = eventModel;
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
}
