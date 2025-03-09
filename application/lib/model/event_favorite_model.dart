import 'package:application/model/favorite_dto.dart';
import 'package:flutter/cupertino.dart';

class EventFavoriteModel with ChangeNotifier {
  late String userId;

  EventFavoriteModel({
    required this.userId,
  });

  factory EventFavoriteModel.createEmpty() {
    return EventFavoriteModel(
      userId: '',
    );
  }

  FavoriteDTO toDTO() {
    return FavoriteDTO(
      userId: userId,
    );
  }

  factory EventFavoriteModel.fromDTO(FavoriteDTO favoriteDTO) {
    return EventFavoriteModel(
      userId: favoriteDTO.userId!,
    );
  }

  void updateLike(EventFavoriteModel newModel) {
    userId = newModel.userId;
    notifyListeners();
  }

}
