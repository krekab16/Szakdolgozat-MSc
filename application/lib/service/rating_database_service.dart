import 'package:application/model/rating_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event_dto.dart';

class RatingDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRatingToDB(RatingDTO ratingDTO) async {
    try {
      QuerySnapshot existingRatings = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: ratingDTO.userId)
          .where('eventId', isEqualTo: ratingDTO.eventId)
          .get();

      if (existingRatings.docs.isNotEmpty) {
        String ratingId = existingRatings.docs.first.id;
        await _firestore.collection('ratings').doc(ratingId).update({
          'rating': ratingDTO.rating,
        });
      } else {
        await _firestore.collection('ratings').add({
          'userId': ratingDTO.userId,
          'eventId': ratingDTO.eventId,
          'rating': ratingDTO.rating,
        });
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<double> getMyRating(String userId, String eventId) async {
    try {
      QuerySnapshot ratingSnapshot = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (ratingSnapshot.docs.isNotEmpty) {
        double rating = ratingSnapshot.docs.first.get('rating');
        return rating;
      }
      return 0.0;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<EventDTO>> fetchMyRatedEvent(String userId) async {
    try {
      QuerySnapshot ratingsSnapshot = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .where('rating', isEqualTo: 5.0)
          .get();

      List<String> ratedEventIds = ratingsSnapshot.docs
          .map((doc) => doc.get('eventId') as String)
          .toList();

      QuerySnapshot eventsSnapshot = await _firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: ratedEventIds)
          .get();

      List<EventDTO> events = eventsSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventDTO.fromJson(data, doc.id);
      }).toList();
      return events;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<double>> getAllRatingValueForEvent(String eventId) async {
    try {
      QuerySnapshot ratingSnapshot = await _firestore
          .collection('ratings')
          .where('eventId', isEqualTo: eventId)
          .get();
      List<double> ratings = ratingSnapshot.docs
          .map((doc) => (doc['rating'] as num).toDouble())
          .toList();
      return ratings;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}