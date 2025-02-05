import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/created_event_screen_view_model.dart';

class CreatedEventScreen extends StatefulWidget {
  const CreatedEventScreen({Key? key}) : super(key: key);

  @override
  State<CreatedEventScreen> createState() => _CreatedEventScreenState();
}

class _CreatedEventScreenState extends State<CreatedEventScreen> {
  @override
  Widget build(BuildContext context) {
    final createdEventViewModel = Provider.of<CreatedEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          created,
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
                children: createdEventViewModel.createdEventModel.events
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
