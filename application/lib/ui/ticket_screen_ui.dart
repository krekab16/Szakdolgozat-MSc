import 'package:application/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../model/my_ticket_with_event_dto.dart';
import '../utils/text_strings.dart';

class TicketScreen extends StatelessWidget {
  final MyTicketWithEventDTO myTicketWithEventDTO;

  const TicketScreen(this.myTicketWithEventDTO, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ticketQRcode),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    myTicketWithEventDTO.eventDTO.name,
                    style: Styles.qrCodeCardEventNameText
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      myTicketWithEventDTO.eventDTO.address,
                      style: Styles.qrCodeCardEventLocationText
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: QrImageView(
                      data: myTicketWithEventDTO.ticketDTO.ticketId!,
                      version: QrVersions.auto,
                      size: 200.0,
                      gapless: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      showYourTicket,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
