import 'package:application/service/rating_database_service.dart';
import 'package:flutter/material.dart';
import '../model/event_dto.dart';
import '../model/event_model.dart';
import '../model/rated_event_model.dart';
import '../utils/text_strings.dart';

class RatedEventViewModel with ChangeNotifier {

  RatedEventModel ratedEventModel = RatedEventModel();
  final RatingDatabaseService service = RatingDatabaseService();
  List<String> errorMessages = [];

  Future<void> fetchRatedEvent(String userId) async {
    try {
      final List<EventDTO> eventDTO = await service.fetchMyRatedEvent(userId);
      final List<EventModel> eventModel =
      eventDTO.map((dto) => EventModel.fromDTO(dto)).toList();
      ratedEventModel.events = eventModel;
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