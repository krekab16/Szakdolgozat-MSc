import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/rated_event_view_model.dart';

class RatedEventScreen extends StatefulWidget {
  const RatedEventScreen({Key? key}) : super(key: key);

  @override
  State<RatedEventScreen> createState() => _RatedEventScreenState();
}

class _RatedEventScreenState extends State<RatedEventScreen> {
  @override
  Widget build(BuildContext context) {
    final ratedEventViewModel = Provider.of<RatedEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          rated,
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
                children: ratedEventViewModel.ratedEventModel.events
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
