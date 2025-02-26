import 'package:application/model/rating_dto.dart';
import 'package:flutter/cupertino.dart';

class EventRatingModel with ChangeNotifier {
  late String userId;
  late double rating;

  EventRatingModel({
    required this.userId,
    required this.rating,
  });

  factory EventRatingModel.createEmpty() {
    return EventRatingModel(
      userId: '',
      rating: 0,
    );
  }

  RatingDTO toDTO() {
    return RatingDTO(
      userId: userId,
      rating: rating,
    );
  }

  factory EventRatingModel.fromDTO(RatingDTO ratingDTO) {
    return EventRatingModel(
      userId: ratingDTO.userId!,
      rating: ratingDTO.rating,
    );
  }

  void updateRating(EventRatingModel newModel) {
    this.userId = newModel.userId;
    this.rating = newModel.rating;
    notifyListeners();
  }

}
