import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/participated_event_view_model.dart';

class ParticipatedEventScreen extends StatefulWidget {
  const ParticipatedEventScreen({Key? key}) : super(key: key);

  @override
  State<ParticipatedEventScreen> createState() => _ParticipatedEventScreenState();
}

class _ParticipatedEventScreenState extends State<ParticipatedEventScreen> {
  @override
  Widget build(BuildContext context) {
    final participatedEventViewModel =
        Provider.of<ParticipatedEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          participatedEvents,
          style: Styles.textStyles,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: participatedEventViewModel
                    .participatedEventModel.events
                    .map((event) => EventBox(event))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
