class RatingDTO {
  late String? ratingId;
  late String? eventId;
  late String? userId;
  late double? rating;

  RatingDTO({
    this.ratingId,
    this.eventId,
    this.userId,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'ratingId': ratingId,
      'eventId': eventId,
      'userId': userId,
      'rating': rating,
    };
  }

  factory RatingDTO.fromJson(Map<String, dynamic> json, String ratingId, String eventId,String userId) {
    return RatingDTO(
      ratingId: ratingId,
      eventId: eventId,
      userId: userId,
      rating: json['rating'],
    );
  }
}