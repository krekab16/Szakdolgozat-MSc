import 'package:application/model/rating_dto.dart';
import 'package:flutter/cupertino.dart';

class UserRatingModel with ChangeNotifier {
  late String eventId;
  late String ratingId;

  UserRatingModel({
    required this.eventId,
    required this.ratingId,
  });

  factory UserRatingModel.createEmpty() {
    return UserRatingModel(
      eventId: '',
      ratingId: '',
    );
  }

  RatingDTO toDTO() {
    return RatingDTO(
      eventId: eventId,
      ratingId: ratingId,
    );
  }

  factory UserRatingModel.fromDTO(RatingDTO ratingDTO) {
    return UserRatingModel(
      eventId: ratingDTO.eventId!,
      ratingId: ratingDTO.ratingId!,
    );
  }

  void updateRating(UserRatingModel newModel) {
    this.eventId = newModel.eventId;
    this.ratingId = newModel.ratingId;
    notifyListeners();
  }

}
