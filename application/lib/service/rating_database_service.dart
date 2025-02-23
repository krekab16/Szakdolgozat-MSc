import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event_dto.dart';

class RatingDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addRating(String userId, String eventId, double rating) async {
    try {
      QuerySnapshot existingRatings = await _firestore
          .collection('ratings')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

      if (existingRatings.docs.isNotEmpty) {
        String ratingId = existingRatings.docs.first.id;
        await _firestore.collection('ratings').doc(ratingId).update({
          'rating': rating,
        });
      } else {
        DocumentReference ratingDoc = await _firestore.collection('ratings').add({
          'userId': userId,
          'eventId': eventId,
          'rating': rating,
        });
        await _firestore.collection('users').doc(userId).update({
          'ratings': FieldValue.arrayUnion([ratingDoc.id]),
        });
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }


  Future<double> getRating(String userId, String eventId) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        List<String> ratingIds = List<String>.from(userSnapshot.get('ratings') ?? []);
        for (String ratingId in ratingIds) {
          DocumentReference ratingRef = _firestore.collection('ratings').doc(ratingId);
          DocumentSnapshot ratingSnapshot = await ratingRef.get();
          if (ratingSnapshot.exists) {
            String eventIdFromDb = ratingSnapshot.get('eventId');
            if (eventIdFromDb == eventId) {
              double rating = ratingSnapshot.get('rating');
              return rating;
            }
          }
        }
      }
      return 0.0;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<EventDTO>> fetchRatedEvent(String userId) async {
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

}