import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/event_dto.dart';
import '../utils/text_strings.dart';
import 'dart:io';

class EventDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<EventDTO>> getEvents() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('events').orderBy('date').get();
      final List<EventDTO> events =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return EventDTO.fromJson(data, doc.id);
      }).toList());
      return events;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<EventDTO>> getEventsForToday() async {
    try {
      DateTime startOfDay(DateTime dateTime) {
        return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
      }

      DateTime endOfDay(DateTime dateTime) {
        return DateTime(
            dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
      }

      final QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('date',
              isGreaterThanOrEqualTo: startOfDay(DateTime.now()),
              isLessThanOrEqualTo: endOfDay(DateTime.now()))
          .get();
      final List<EventDTO> events =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return EventDTO.fromJson(data, doc.id);
      }).toList());
      return events;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updateEvent(EventDTO eventDTO) async {
    try {
      await _firestore
          .collection('events')
          .doc(eventDTO.id)
          .update(eventDTO.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> addParticipation(String userId, EventDTO eventDTO) async {
    try {
      final DocumentSnapshot docSnapshot =
          await _firestore.collection('events').doc(eventDTO.id).get();
      final int participationCount = docSnapshot.get('participationCount');
      final int stuffLimit = eventDTO.stuffLimit;

      if (participationCount < stuffLimit) {
        await _firestore.collection('events').doc(eventDTO.id).update({
          'participationCount': FieldValue.increment(1),
          'participants': FieldValue.arrayUnion([userId]),
        });
      } else {
        throw Exception(participationErrorMessage);
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> removeParticipation(String userId, EventDTO eventDTO) async {
    try {
      final DocumentSnapshot docSnapshot =
          await _firestore.collection('events').doc(eventDTO.id).get();

      if (userId.isNotEmpty &&
          docSnapshot.get('participants').contains(userId)) {
        await _firestore.collection('events').doc(eventDTO.id).update({
          'participationCount': FieldValue.increment(-1),
          'participants': FieldValue.arrayRemove([userId])
        });
      } else {
        throw Exception(currentUserNotParticipatingErrorMessage);
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<EventDTO>> getFavouriteEvent(String userId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();

      final Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?;
      final List<dynamic> favorites = data?['favorites'] ?? [];
      final QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: favorites)
          .get();

      final List<EventDTO> events =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return EventDTO.fromJson(data, doc.id);
      }).toList());

      return events;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<EventDTO>> getMyEvents(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('createdBy', isEqualTo: userId)
          .get();
      final List<EventDTO> events =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return EventDTO.fromJson(data, doc.id);
      }).toList());
      return events;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<EventDTO>> getParticipatedEvent(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('participants', arrayContains: userId)
          .get();

      final List<EventDTO> events =
          await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        return EventDTO.fromJson(data, doc.id);
      }).toList());

      return events;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addEventToDatabase(
      String userId, EventDTO eventDTO, File imageFile) async {
    try {
      final String imageName = '${eventDTO.name}_${DateTime.now()}.jpg';
      final Reference storageReference = _storage.ref(imageName);
      final UploadTask uploadTask = storageReference.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      eventDTO.image = downloadUrl;
      final eventData = eventDTO.toJson();
      eventData.addAll({
        'createdBy': userId,
        'participationCount': 0,
      });
      await _firestore.collection('events').add(eventData);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
