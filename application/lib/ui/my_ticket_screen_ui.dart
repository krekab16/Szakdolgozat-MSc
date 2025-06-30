import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../utils/ticket_card.dart';
import '../viewmodel/my_ticket_view_model.dart';

class MyTicketScreen extends StatefulWidget {

  const MyTicketScreen({Key? key}) : super(key: key);

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  @override
  Widget build(BuildContext context) {
    final myTicketViewModel = Provider.of<MyTicketViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          tickets,
          style: Styles.textStyles,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: myTicketViewModel.ticketModel.myTicketsWithEvents
                    .map((ticketDTO) => TicketCard(ticketDTO))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
