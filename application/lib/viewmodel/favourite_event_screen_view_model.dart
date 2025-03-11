import 'package:application/model/event_model.dart';
import 'package:flutter/material.dart';
import '../model/event_dto.dart';
import '../model/liked_event_model.dart';
import '../service/favorite_database_service.dart';
import '../utils/text_strings.dart';

class FavouriteEventViewModel with ChangeNotifier {
  LikedEventModel likedEventModel = LikedEventModel();
  final FavoriteDatabaseService service = FavoriteDatabaseService();
  List<String> errorMessages = [];

  Future<void> fetchFavouriteEvent(String userId) async {
    try {
      final List<EventDTO> eventDTO = await service.fetchMyLikedEvent(userId);
      final List<EventModel> eventModel =
          eventDTO.map((dto) => EventModel.fromDTO(dto)).toList();
      likedEventModel.events = eventModel;
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
