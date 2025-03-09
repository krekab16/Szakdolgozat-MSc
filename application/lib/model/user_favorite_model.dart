import 'package:flutter/cupertino.dart';
import 'favorite_dto.dart';

class UserFavoriteModel with ChangeNotifier {
  late String eventId;

  UserFavoriteModel({
    required this.eventId,
  });

  factory UserFavoriteModel.createEmpty() {
    return UserFavoriteModel(
      eventId: '',
    );
  }

  FavoriteDTO toDTO() {
    return FavoriteDTO(
      eventId: eventId,
    );
  }

  factory UserFavoriteModel.fromDTO(FavoriteDTO favoriteDTO) {
    return UserFavoriteModel(
      eventId: favoriteDTO.eventId!,
    );
  }

  void updateRating(UserFavoriteModel newModel) {
    eventId = newModel.eventId;
    notifyListeners();
  }

}
