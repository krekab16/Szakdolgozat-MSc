import 'package:application/utils/colors.dart';
import 'package:flutter/material.dart';
import '../model/event_model.dart';
import '../ui/event_screen_ui.dart';
import '../utils/styles.dart';

class EventBox extends StatefulWidget {
  final EventModel eventModel;

  const EventBox(this.eventModel, {Key? key}) : super(key: key);

  @override
  State<EventBox> createState() => _EventBoxState();
}

class _EventBoxState extends State<EventBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColors.lightBlueColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventScreen(widget.eventModel),
                    ),
                  );
                },
                child: Image.network(
                  widget.eventModel.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                widget.eventModel.name,
                style: Styles.eventBoxText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
