import 'package:application/model/ticket_dto.dart';
import 'event_dto.dart';

class MyTicketWithEventDTO {
  final TicketDTO ticketDTO;
  final EventDTO eventDTO;

  MyTicketWithEventDTO({
    required this.ticketDTO,
    required this.eventDTO,
  });
}
