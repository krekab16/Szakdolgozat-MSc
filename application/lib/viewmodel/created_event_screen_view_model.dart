import 'package:flutter/material.dart';
import '../model/created_event_model.dart';
import 'package:application/model/event_model.dart';
import '../model/event_dto.dart';
import '../service/event_database_service.dart';
import '../utils/text_strings.dart';

class CreatedEventViewModel with ChangeNotifier {
  final EventDatabaseService service = EventDatabaseService();
  final CreatedEventModel createdEventModel = CreatedEventModel();

  List<String> errorMessages = [];

  Future<void> fetchCreatedEvents(String userId) async {
    try {
      final List<EventDTO> eventDTOs = await service.getMyEvents(userId);
      final List<EventModel> eventModels =
          eventDTOs.map((dto) => EventModel.fromDTO(dto)).toList();
      createdEventModel.events = eventModels;
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
