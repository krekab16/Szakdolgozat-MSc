import 'package:application/model/event_model.dart';
import 'package:application/model/my_ticket_with_event_dto.dart';
import 'package:application/model/rating_dto.dart';
import 'package:application/model/user_favorite_model.dart';
import 'package:application/model/user_model.dart';
import 'package:application/model/user_rating_model.dart';
import 'package:flutter/widgets.dart';
import '../model/event_favorite_model.dart';
import '../model/event_rating_model.dart';
import '../model/favorite_dto.dart';
import '../model/ticket_dto.dart';
import '../service/event_database_service.dart';
import '../service/favorite_database_service.dart';
import '../service/rating_database_service.dart';
import '../service/ticket_database_service.dart';
import '../service/user_database_service.dart';
import '../utils/text_strings.dart';

class EventViewModel with ChangeNotifier {
  final EventDatabaseService service = EventDatabaseService();
  final RatingDatabaseService ratingService = RatingDatabaseService();
  final UserDatabaseService userService = UserDatabaseService();
  final FavoriteDatabaseService favoriteService = FavoriteDatabaseService();
  final TicketDatabaseService ticketService = TicketDatabaseService();

  List<String> errorMessages = [];

  List<String> generatedTickets = [];

  Future<void> addLikeToEvent(String userId, String eventId, UserModel userModel, EventModel eventModel) async {
    try {
      FavoriteDTO favoriteDTO = FavoriteDTO(userId: userId, eventId: eventId);
      await favoriteService.addLikeToDB(favoriteDTO);
      UserFavoriteModel newUserLike = UserFavoriteModel(eventId: eventId);
      userModel.updateUserFavoritesList(newUserLike);
      EventFavoriteModel newEventLike = EventFavoriteModel(userId: userId);
      eventModel.updateEventFavoritesList(newEventLike);
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

  Future<bool> getMyLikeForEvent(String userId, String eventId, UserModel userModel) async {
    try {
      UserFavoriteModel? userLike = userModel.favorites?.firstWhere(
            (like) => like.eventId == eventId,
        orElse: () => UserFavoriteModel(eventId: eventId),
      );
      bool isLiked = await favoriteService.getMyLike(userId, eventId);
      if (isLiked && userLike == null) {
        UserFavoriteModel newUserLike = UserFavoriteModel(eventId: eventId);
        userModel.updateUserFavoritesList(newUserLike);
      }
      errorMessages = [];
      return isLiked;
    } catch (e) {
      errorMessages = [standardErrorMessage];
      return false;
    } finally {
      notifyListeners();
    }
  }


  Future<void> removeLikeFromEvent(String userId, String eventId, UserModel userModel, EventModel eventModel) async {
    try {
      await favoriteService.removeLikeFromDB(userId, eventId);
      userModel.removeUserFavorite(eventId);
      eventModel.removeEventFavorite(userId);
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

  Future<void> addRatingToEvent(String userId, String eventId, double rating, UserModel userModel, EventModel eventModel) async {
    try {
      RatingDTO ratingDTO = RatingDTO(userId: userId, eventId: eventId, rating: rating);
      await ratingService.addRatingToDB(ratingDTO);

      UserRatingModel newUserRating = UserRatingModel(eventId: eventId, rating: rating);
      userModel.updateUserRatingsList(newUserRating);

      EventRatingModel newEventRating = EventRatingModel(userId: userId, rating: rating);
      eventModel.updateEventRatingsList(newEventRating);
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

  Future<double> getMyRatingValueForEvent(String userId, String eventId, UserModel userModel) async {
    try {
      UserRatingModel? userRating = userModel.ratings?.firstWhere(
            (rating) => rating.eventId == eventId,
        orElse: () => UserRatingModel(eventId: eventId, rating: 0.0),
      );
      double rating = userRating?.rating ?? 0.0;
      if (rating == 0.0) {
        rating = await ratingService.getMyRating(userId, eventId);
        if (rating != 0.0) {
          UserRatingModel newUserRating = UserRatingModel(eventId: eventId, rating: rating);
          userModel.updateUserRatingsList(newUserRating);
        }
      }
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

  Future<Map<String, dynamic>> getRatingValuesForEvent(String eventId, EventModel eventModel) async {
    try {
      List<double> ratings = eventModel.ratings?.map((e) => e.rating).toList() ?? [];

      if (ratings.isEmpty) {
        ratings = await ratingService.getAllRatingValueForEvent(eventId);
      }

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

      Map<int, int> starCounters = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      double sumRatings = 0;

      for (double rating in ratings) {
        sumRatings += rating;
        int star = rating.toInt();
        if (starCounters.containsKey(star)) {
          starCounters[star] = starCounters[star]! + 1;
        }
      }

      double average = sumRatings / ratings.length;

      return {
        'counter': ratings.length,
        'average': average,
        'counterOneStars': starCounters[1]!,
        'counterTwoStars': starCounters[2]!,
        'counterThreeStars': starCounters[3]!,
        'counterFourStars': starCounters[4]!,
        'counterFiveStars': starCounters[5]!,
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

  Future<MyTicketWithEventDTO?> addAndGetTicketData(String userId, EventModel eventModel) async {
    try {
      TicketDTO ticketDTO = TicketDTO(userId: userId, eventId: eventModel.id);
      final MyTicketWithEventDTO? ticketData = await ticketService.addAndGetTicketToDB(ticketDTO);
      errorMessages = [];
      notifyListeners();
      return ticketData;
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
      notifyListeners();
      return null;
    }
  }

}
