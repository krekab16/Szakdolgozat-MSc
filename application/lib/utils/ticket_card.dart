import 'package:application/ui/ticket_screen_ui.dart';
import 'package:application/utils/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../model/my_ticket_with_event_dto.dart';
import '../utils/styles.dart';

class TicketCard extends StatefulWidget {
  final MyTicketWithEventDTO myTicketWithEventDTO;

  const TicketCard(this.myTicketWithEventDTO, {Key? key}) : super(key: key);

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketScreen(widget.myTicketWithEventDTO),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (widget.myTicketWithEventDTO.ticketDTO.ticketId != null)
                      QrImageView(
                        data: widget.myTicketWithEventDTO.ticketDTO.ticketId!,
                        version: QrVersions.auto,
                        size: 80,
                        gapless: false,
                      )
                    else
                      const Icon(Icons.qr_code_2_rounded, size: 80, color: Colors.grey),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                widget.myTicketWithEventDTO.eventDTO.name,
                                style: Styles.ticketCardEventNameText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                location,
                                style: Styles.ticketCardText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                widget.myTicketWithEventDTO.eventDTO.address,
                                style: Styles.ticketCardText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
