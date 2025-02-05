import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/favourite_event_screen_view_model.dart';

class FavouriteEventScreen extends StatefulWidget {
  const FavouriteEventScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteEventScreen> createState() => _FavouriteEventScreenState();
}

class _FavouriteEventScreenState extends State<FavouriteEventScreen> {
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel = Provider.of<FavouriteEventViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          favourites,
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
                children: favouriteViewModel.favouriteEventModel.events
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
