import 'package:application/model/event_model.dart';
import 'package:flutter/material.dart';
import '../model/event_dto.dart';
import '../model/participated_event_model.dart';
import '../service/event_database_service.dart';
import '../utils/text_strings.dart';

class ParticipatedEventViewModel with ChangeNotifier {
  ParticipatedEventModel participatedEventModel = ParticipatedEventModel();

  final EventDatabaseService service = EventDatabaseService();

  List<String> errorMessages = [];

  Future<void> fetchParticipatedEvent(String userId) async {
    try {
      final List<EventDTO> eventDTO =
          await service.getParticipatedEvent(userId);
      final List<EventModel> eventModel =
          eventDTO.map((dto) => EventModel.fromDTO(dto)).toList();
      participatedEventModel.events = eventModel;
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
