import 'package:application/model/rating_dto.dart';
import 'package:flutter/cupertino.dart';

class UserRatingModel with ChangeNotifier {
  late String eventId;
  late double rating;

  UserRatingModel({
    required this.eventId,
    required this.rating,
  });

  factory UserRatingModel.createEmpty() {
    return UserRatingModel(
      eventId: '',
      rating: 0,
    );
  }

  RatingDTO toDTO() {
    return RatingDTO(
      eventId: eventId,
      rating: rating,
    );
  }

  factory UserRatingModel.fromDTO(RatingDTO ratingDTO) {
    return UserRatingModel(
      eventId: ratingDTO.eventId!,
      rating: ratingDTO.rating,
    );
  }

  void updateRating(UserRatingModel newModel) {
    this.eventId = newModel.eventId;
    this.rating  = newModel.rating;
    notifyListeners();
  }

}
