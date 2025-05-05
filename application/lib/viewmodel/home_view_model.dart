import 'package:application/model/event_model.dart';
import 'package:application/model/home_model.dart';
import 'package:application/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/event_dto.dart';
import '../model/recommended_event_model.dart';
import '../service/event_database_service.dart';
import '../ui/map_screen_ui.dart';
import '../utils/text_strings.dart';
import 'map_view_model.dart';

class HomeViewModel with ChangeNotifier {
  HomeModel homeModel = HomeModel();
  UserModel userModel = UserModel.createEmpty();

  final EventDatabaseService service = EventDatabaseService();
  RecommendedEventModel recommendedEvents = RecommendedEventModel();

  List<String> errorMessages = [];

  HomeViewModel() {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final List<EventDTO> eventDTO = await service.getEvents();
      final List<EventModel> eventModel =
      eventDTO.map((dto) => EventModel.fromDTO(dto)).toList();
      homeModel.events = eventModel;
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

  void navigateToMapScreen(BuildContext context) async{
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) =>
          MapViewModel()..requestLocationPermission(context)..fetchMarkersFromEventData(context),
          child: const MapScreen(),
        ),
      ),
    );
  }

  Future<void> fetchRecommendedEvents(String userId) async {
    try {
      final List<EventDTO> eventDTO =
      await service.getRecommendedEventsForUser(userId);
      final List<EventModel> eventModel =
      eventDTO.map((dto) => EventModel.fromDTO(dto)).toList();
      recommendedEvents.events = eventModel;
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