class UserDTO {
  late String name;
  late String username;
  late String email;
  late String password;
  late bool isOrganizer;
  late String id;
  late String? token;

  UserDTO({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.isOrganizer,
    required this.id,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'isOrganizer': isOrganizer,
    };
  }

  factory UserDTO.fromJson(Map<String, dynamic> json, String id) {
    return UserDTO(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      isOrganizer: json['isOrganizer'],
      id: id,
      token: json['token'],
    );
  }
}
