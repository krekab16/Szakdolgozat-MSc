class TicketDTO {
  late String? ticketId;
  late String? eventId;
  late String? userId;

  TicketDTO({
    this.ticketId,
    this.eventId,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'ticketId': ticketId,
      'eventId': eventId,
      'userId': userId,
    };
  }

  factory TicketDTO.fromJson(Map<String, dynamic> json,String ticketId) {
    return TicketDTO(
      ticketId: ticketId,
      eventId: json['eventId'],
      userId: json['userId'],
    );
  }
}