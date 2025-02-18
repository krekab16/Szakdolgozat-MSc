class UserDTO {
  late String name;
  late String username;
  late String email;
  late String password;
  late bool isOrganizer;
  List<String>? favorites;
  Map<String, double>? ratings;
  late String id;

  UserDTO({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.isOrganizer,
    required this.id,
    this.favorites,
    this.ratings,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'isOrganizer': isOrganizer,
      'favorites': favorites,
      'ratings': ratings,
    };
  }

  factory UserDTO.fromJson(Map<String, dynamic> json, String id) {
    return UserDTO(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      isOrganizer: json['isOrganizer'],
      favorites: List<String>.from(json['favorites'] as List),
      ratings: Map<String, double>.from(json['ratings'] as Map),
      id: id,
    );
  }
}
