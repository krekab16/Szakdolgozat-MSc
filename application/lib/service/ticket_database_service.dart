import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event_dto.dart';
import '../model/my_ticket_with_event_dto.dart';
import '../model/ticket_dto.dart';

class TicketDatabaseService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MyTicketWithEventDTO?> addAndGetTicketToDB(TicketDTO ticketDTO) async {
    try {
      QuerySnapshot existingTicket = await _firestore
          .collection('tickets')
          .where('userId', isEqualTo: ticketDTO.userId)
          .where('eventId', isEqualTo: ticketDTO.eventId)
          .get();
      if (existingTicket.docs.isNotEmpty) {
        String ticketId = existingTicket.docs.first.id;
        DocumentSnapshot eventDoc = await _firestore
            .collection('events')
            .doc(ticketDTO.eventId)
            .get();
        EventDTO eventDTO = EventDTO.fromJson(eventDoc.data() as Map<String, dynamic>, eventDoc.id);
        TicketDTO ticket = TicketDTO.fromJson(existingTicket.docs.first.data() as Map<String, dynamic>, ticketId);
        return MyTicketWithEventDTO(ticketDTO: ticket, eventDTO: eventDTO);
      }
      DocumentReference ticketRef = await _firestore.collection('tickets').add({
        'userId': ticketDTO.userId,
        'eventId': ticketDTO.eventId,
      });
      DocumentSnapshot eventDoc = await _firestore
          .collection('events')
          .doc(ticketDTO.eventId)
          .get();
      EventDTO eventDTO = EventDTO.fromJson(eventDoc.data() as Map<String, dynamic>, eventDoc.id);
      await _firestore.collection('events').doc(ticketDTO.eventId).update({
        'expectedTicketId': FieldValue.arrayUnion([ticketRef.id]),
      });


      TicketDTO ticket = TicketDTO(userId: ticketDTO.userId, eventId: ticketDTO.eventId, ticketId: ticketRef.id);
      return MyTicketWithEventDTO(ticketDTO: ticket, eventDTO: eventDTO);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<MyTicketWithEventDTO>> fetchMyTicketsWithEventData(String userId) async {
    try {
      QuerySnapshot ticketSnapshot = await _firestore
          .collection('tickets')
          .where('userId', isEqualTo: userId)
          .get();
      List<TicketDTO> tickets = ticketSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TicketDTO.fromJson(data, doc.id);
      }).toList();
      List<String> eventIds = tickets.map((ticket) => ticket.eventId!).toList();
      QuerySnapshot eventSnapshot = await _firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: eventIds)
          .get();
      Map<String, EventDTO> eventMap = {
        for (var doc in eventSnapshot.docs)
          doc.id: EventDTO.fromJson(doc.data() as Map<String, dynamic>, doc.id)
      };
      List<MyTicketWithEventDTO> myTicketsWithEvents = tickets.map((ticket) {
        final event = eventMap[ticket.eventId];
        return MyTicketWithEventDTO(ticketDTO: ticket, eventDTO: event!);
      }).toList();

      return myTicketsWithEvents;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> validateQrCodeForEvent(String qrCode, String eventId) async {
    try {
      DocumentSnapshot eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (eventDoc.exists) {
        String expectedTicketId = eventDoc['expectedTicketId'];
        if (qrCode == expectedTicketId) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

}