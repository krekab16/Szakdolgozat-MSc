import 'package:application/model/event_model.dart';
import 'package:application/model/rating_dto.dart';
import 'package:application/model/user_model.dart';
import 'package:flutter/widgets.dart';
import '../service/event_database_service.dart';
import '../service/rating_database_service.dart';
import '../service/user_database_service.dart';
import '../utils/text_strings.dart';

class EventViewModel with ChangeNotifier {
  final EventDatabaseService service = EventDatabaseService();
  final RatingDatabaseService ratingService = RatingDatabaseService();
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

  Future<void> addRatingToEvent(String userId, String eventId, double rating) async {
    try {
      RatingDTO ratingDTO = RatingDTO(userId: userId, eventId: eventId, rating: rating);
      await ratingService.addRating(ratingDTO);
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


  Future<double> getMyRatingForEvent(String userId, String eventId) async {
    try {
      double rating = await ratingService.getMyRating(userId, eventId);
      errorMessages = [];
      return rating;
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
      return 0.0;
    } finally {
      notifyListeners();
    }
  }


  Future<Map<String, dynamic>> getRatingValuesForEvent(String eventId) async {
    try {
      List<double> ratings = await ratingService.getAllRatingValueForEvent(eventId);

      if (ratings.isEmpty) {
        return {
          'counter': 0,
          'average': 0.0,
          'counterOneStars': 0,
          'counterTwoStars': 0,
          'counterThreeStars': 0,
          'counterFourStars': 0,
          'counterFiveStars': 0,
        };
      }

      int counterOneStars = 0;
      int counterTwoStars = 0;
      int counterThreeStars = 0;
      int counterFourStars = 0;
      int counterFiveStars = 0;

      double sumRatings = 0;

      for (double rating in ratings) {
        sumRatings += rating;

        if (rating == 1.0) counterOneStars++;
        if (rating == 2.0) counterTwoStars++;
        if (rating == 3.0) counterThreeStars++;
        if (rating == 4.0) counterFourStars++;
        if (rating == 5.0) counterFiveStars++;
      }

      double average = sumRatings / ratings.length;

      return {
        'counter': ratings.length,
        'average': average,
        'counterOneStars': counterOneStars,
        'counterTwoStars': counterTwoStars,
        'counterThreeStars': counterThreeStars,
        'counterFourStars': counterFourStars,
        'counterFiveStars': counterFiveStars,
      };
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
      return {};
    } finally {
      notifyListeners();
    }
  }

  Future<bool> getParticipationStatusForUser(String userId, String eventId) async {
    try {
      bool isParticipated = await userService.getParticipationStatusForUser(userId, eventId);
      errorMessages = [];
      return isParticipated;
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
      return false;
    }
  }

}
