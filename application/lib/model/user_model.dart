import 'package:application/model/user_dto.dart';
import 'package:application/model/user_rating_model.dart';
import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  late String name;
  late String username;
  late String email;
  late String password;
  late bool isOrganizer;
  List<String>? favorites;
  List<UserRatingModel>? ratings;
  late String id;

  UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.isOrganizer,
    required this.id,
    this.favorites,
    this.ratings,
  });

  factory UserModel.createEmpty() {
    return UserModel(
        name: '',
        username: '',
        email: '',
        password: '',
        isOrganizer: false,
        id: '',
        favorites: [],
        ratings: [],
    );
  }

  UserDTO toDTO() {
    return UserDTO(
      name: name,
      username: username,
      email: email,
      password: password,
      isOrganizer: isOrganizer,
      favorites: favorites,
      id: id,
    );
  }

  factory UserModel.fromDTO(UserDTO userDTO) {
    return UserModel(
      name: userDTO.name,
      username: userDTO.username,
      email: userDTO.email,
      password: userDTO.password,
      isOrganizer: userDTO.isOrganizer,
      favorites: userDTO.favorites,
      id: userDTO.id,
    );
  }

  void updateUser(UserModel newModel) {
    this.id = newModel.id;
    this.name = newModel.name;
    this.username = newModel.username;
    this.email = newModel.email;
    this.password = newModel.password;
    this.isOrganizer = newModel.isOrganizer;
    this.favorites = newModel.favorites;
    this.ratings = newModel.ratings;
    notifyListeners();
  }

  void updateOrganiserState(bool isOrganiser) {
    this.isOrganizer = isOrganiser;
    notifyListeners();
  }

  void addRating(UserRatingModel rating) {
    ratings?.add(rating);
  }

  void updateUserRatingsList(UserRatingModel newRating) {
    var existingRating = ratings?.firstWhere(
          (rating) => rating.eventId == newRating.eventId,
      orElse: () => UserRatingModel(eventId: newRating.eventId, rating: 0.0),
    );
    if (existingRating != null) {
      existingRating.rating = newRating.rating;
    } else {
      ratings?.add(newRating);
    }
  }

}
