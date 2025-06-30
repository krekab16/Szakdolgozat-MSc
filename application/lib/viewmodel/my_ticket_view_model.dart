import 'package:application/model/my_ticket_with_event_dto.dart';
import 'package:application/service/ticket_database_service.dart';
import 'package:flutter/material.dart';
import '../model/ticket_model.dart';
import '../utils/text_strings.dart';

class MyTicketViewModel with ChangeNotifier {

  final TicketDatabaseService service = TicketDatabaseService();

  TicketModel ticketModel = TicketModel();

  List<String> errorMessages = [];

  Future<void> fetchMyTicket(String userId) async {
    try {
      final List<MyTicketWithEventDTO> myTicketsWithEvents = await service.fetchMyTicketsWithEventData(userId);
      ticketModel.myTicketsWithEvents = myTicketsWithEvents;
      errorMessages = [];
    } catch (e) {
      if (e.toString().isNotEmpty) {
        errorMessages = [e.toString()];
      } else {
        errorMessages = [standardErrorMessage];
      }
    }
    notifyListeners();
  }

}
