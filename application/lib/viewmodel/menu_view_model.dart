import 'package:application/viewmodel/profile_view_model.dart';
import 'package:application/viewmodel/participated_event_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/user_database_service.dart';
import '../ui/favourite_event_screen_ui.dart';
import '../ui/profile_screen_ui.dart';
import '../ui/participated_event_screen_ui.dart';
import '../utils/route_constants.dart';
import '../utils/text_strings.dart';
import 'favourite_event_screen_view_model.dart';
import '../ui/created_event_screen_ui.dart';
import 'created_event_screen_view_model.dart';

class MenuViewModel with ChangeNotifier {
  final UserDatabaseService service = UserDatabaseService();

  List<String> errorMessages = [];

  Future<void> logOutUser() async {
    try {
      await service.logOut();
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

  void navigateToProfile(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ProfileViewModel()..fetchUserProfile(userId),
          child: const ProfileScreen(),
        ),
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, homeRoute);
  }

  void navigateToParticipatedEvent(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) =>
          ParticipatedEventViewModel()..fetchParticipatedEvent(userId),
          child: const ParticipatedEventScreen(),
        ),
      ),
    );
  }

  void navigateToFavourites(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) =>
              FavouriteEventViewModel()..fetchFavouriteEvent(userId),
          child: const FavouriteEventScreen(),
        ),
      ),
    );
  }

  void navigateToNewEvent(BuildContext context) {
    Navigator.pushNamed(context, newEventRoute);
  }

  void navigateToCreatedEvent(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) =>
          CreatedEventViewModel()..fetchCreatedEvents(userId),
          child: const CreatedEventScreen(),
        ),
      ),
    );
  }


  void logOut(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    Navigator.pushNamed(context, startRoute);
  }
}
