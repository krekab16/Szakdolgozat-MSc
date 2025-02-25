import 'package:application/model/rating_dto.dart';
import 'package:flutter/cupertino.dart';

class EventRatingModel with ChangeNotifier {
  late String userId;
  late String ratingId;

  EventRatingModel({
    required this.userId,
    required this.ratingId,
  });

  factory EventRatingModel.createEmpty() {
    return EventRatingModel(
      userId: '',
      ratingId: '',
    );
  }

  RatingDTO toDTO() {
    return RatingDTO(
      userId: userId,
      ratingId: ratingId,
    );
  }

  factory EventRatingModel.fromDTO(RatingDTO ratingDTO) {
    return EventRatingModel(
      userId: ratingDTO.userId!,
      ratingId: ratingDTO.ratingId!,
    );
  }

  void updateRating(EventRatingModel newModel) {
    this.userId = newModel.userId;
    notifyListeners();
  }

}
