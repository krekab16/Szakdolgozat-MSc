import 'package:application/model/favorite_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event_dto.dart';

class FavoriteDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLikeToDB(FavoriteDTO favoriteDTO) async {
    try {
      QuerySnapshot existingFavorites = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: favoriteDTO.userId)
          .where('eventId', isEqualTo: favoriteDTO.eventId)
          .get();
      if (existingFavorites.docs.isNotEmpty) {
        String favoriteId = existingFavorites.docs.first.id;
        await _firestore.collection('favorites').doc(favoriteId).update({
        });
      } else {
        await _firestore.collection('favorites').add({
          'userId': favoriteDTO.userId,
          'eventId': favoriteDTO.eventId,
        });
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> getMyLike(String userId, String eventId) async {
    try {
      QuerySnapshot favoriteSnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();
      return favoriteSnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<EventDTO>> fetchMyLikedEvent(String userId) async {
    try {
      QuerySnapshot ratingsSnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();
      List<String> likedEventIds = ratingsSnapshot.docs
          .map((doc) => doc.get('eventId') as String)
          .toList();
      QuerySnapshot eventsSnapshot = await _firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: likedEventIds)
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

  Future<void> removeLikeFromDB(String userId, String eventId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('favorites')
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        String favoriteId = querySnapshot.docs.first.id;
        DocumentReference eventRef = _firestore
            .collection('favorites')
            .doc(favoriteId);
        var documentSnapshot = await eventRef.get();
        if (documentSnapshot.exists) {
          await eventRef.delete();
        }
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}