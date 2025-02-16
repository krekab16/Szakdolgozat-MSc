import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/liked_event_view_model.dart';

class LikedEventScreen extends StatefulWidget {
  const LikedEventScreen({Key? key}) : super(key: key);

  @override
  State<LikedEventScreen> createState() => _LikedEventScreenState();
}

class _LikedEventScreenState extends State<LikedEventScreen> {
  @override
  Widget build(BuildContext context) {
    final likedEventViewModel = Provider.of<LikedEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          liked,
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
                children: likedEventViewModel.likedEventModel.events
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
