class FavoriteDTO {
  late String? favoriteId;
  late String? eventId;
  late String? userId;

  FavoriteDTO({
    this.favoriteId,
    this.eventId,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
      'eventId': eventId,
      'userId': userId,
    };
  }

  factory FavoriteDTO.fromJson(Map<String, dynamic> json, String favoriteId, String eventId,String userId) {
    return FavoriteDTO(
      favoriteId: favoriteId,
      eventId: eventId,
      userId: userId,
    );
  }
}