import 'package:flutter/material.dart';
import '../event_recommendation.dart';
import '../model/created_event_model.dart';
import 'package:application/model/event_model.dart';
import '../model/event_dto.dart';
import '../model/organizer_recommend_event_model.dart';
import '../service/event_database_service.dart';
import '../utils/text_strings.dart';

class CreatedEventViewModel with ChangeNotifier {
  final EventDatabaseService service = EventDatabaseService();
  final CreatedEventModel createdEventModel = CreatedEventModel();
  OrganizerRecommendedEventModel organizerRecommendedEventModel = OrganizerRecommendedEventModel();
  final EventRecommendation eventRecommendation = EventRecommendation();


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

  Future<void> fetchRecommendedEventsForOrganizer(String userId) async {
    try {
      final List<EventDTO> allEventDTOs = await service.getEvents();
      final List<EventDTO> myEventDTOs = await service.getMyEvents(userId);
      final List<EventModel> allEvents = allEventDTOs.map((dto) => EventModel.fromDTO(dto)).toList();
      final List<EventModel> myEvents = myEventDTOs.map((dto) => EventModel.fromDTO(dto)).toList();
      if (myEvents.isEmpty) {
        organizerRecommendedEventModel.events = [];
        notifyListeners();
        return;
      }
      final Set<String> recommendedCategories = myEvents.map((e) => e.category).toSet();
      final Set<String> myEventIds = myEvents.map((e) => e.id).toSet();
      final List<EventModel> recommendedEvents = allEvents.where((event) =>
      recommendedCategories.contains(event.category) && !myEventIds.contains(event.id)).toList();
      organizerRecommendedEventModel.events = recommendedEvents;
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
