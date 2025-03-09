import 'package:application/model/event_rating_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'event_dto.dart';
import 'event_favorite_model.dart';

class EventModel with ChangeNotifier{
  String name;
  String address;
  String category;
  DateTime date;
  String image;
  int stuffLimit;
  String description;
  String id;
  List<EventRatingModel>? ratings;
  List<EventFavoriteModel>? favorites;

  EventModel({
    required this.name,
    required this.address,
    required this.category,
    required this.date,
    required this.image,
    required this.stuffLimit,
    required this.description,
    required this.id,
    this.ratings,
    this.favorites,
  });

  factory EventModel.createEmpty() {
    return EventModel(
      name: '',
      address: '',
      category: '',
      date: DateTime.now(),
      image: '',
      stuffLimit: 0,
      description: '',
      id: '',
      ratings: [],
      favorites: [],
    );
  }

  EventDTO toDTO() {
    return EventDTO(
      name: name,
      address: address,
      category: category,
      date: Timestamp.fromDate(date),
      image: image,
      stuffLimit: stuffLimit,
      description: description,
      id: id,
    );
  }

  factory EventModel.fromDTO(EventDTO eventDTO) {
    return EventModel(
      name: eventDTO.name,
      address: eventDTO.address,
      category: eventDTO.category,
      date: eventDTO.date.toDate(),
      image: eventDTO.image,
      stuffLimit: eventDTO.stuffLimit,
      description: eventDTO.description,
      id: eventDTO.id,
    );
  }

  void updateEventRatingsList(EventRatingModel newRating) {
    var existingRating = ratings?.firstWhere(
          (rating) => rating.userId == newRating.userId,
      orElse: () => EventRatingModel(userId: newRating.userId, rating: 0.0),
    );
    if (existingRating != null) {
      existingRating.rating = newRating.rating;
    } else {
      ratings?.add(newRating);
    }
  }

  void updateEventFavoritesList(EventFavoriteModel eventFavoriteModel) {
    var existingLikeIndex = favorites?.indexWhere((liked) => liked.userId == eventFavoriteModel.userId);
    if (existingLikeIndex == -1) {
      favorites?.add(eventFavoriteModel);
    }
    notifyListeners();
  }

  void removeEventFavorite(String userId) {
    favorites?.removeWhere((liked) => liked.userId == userId);
    notifyListeners();
  }

}