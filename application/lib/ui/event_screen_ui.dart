import 'package:application/utils/my_button.dart';
import 'package:application/viewmodel/event_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/event_model.dart';
import '../model/user_model.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';

class EventScreen extends StatefulWidget {
  final EventModel eventModel;

  const EventScreen(this.eventModel, {Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);
    final userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: FutureBuilder<bool>(
        future: eventViewModel.getEventWithFavoriteStatus(
            userModel, widget.eventModel.id),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            _isFavorite = snapshot.data ?? false;
            return ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.eventModel.image),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      left: 10,
                      top: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              eventViewModel.updateEvent(widget.eventModel);
                              eventViewModel.updateUser(userModel);
                              if (eventViewModel.errorMessages.isEmpty) {
                                eventViewModel.navigateBack(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(
                                      errorDialogTitle,
                                      style: Styles.errorText,
                                    ),
                                    content: Text(
                                      eventViewModel.errorMessages.join(" "),
                                      style: Styles.errorText,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(close),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  widget.eventModel.name,
                                  style: Styles.eventTitleStyle,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  widget.eventModel.category,
                                  style: Styles.eventCategoryStyle,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 25,
                              ),
                              Expanded(
                                child: Text(
                                  widget.eventModel.address,
                                  style: Styles.eventAddressStyle,
                                ),
                              )
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(widget.eventModel.date),
                                      style: Styles.eventDateStyle,
                                    ),
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(widget.eventModel.date),
                                      style: Styles.eventDateStyle,
                                    ),
                                  ],
                                ),
                              ]),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                  if (_isFavorite) {
                                    eventViewModel.addFavouriteEvent(
                                        userModel, widget.eventModel.id);
                                    if (eventViewModel.errorMessages.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: successfulAddToFavoritesMessage);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                  errorDialogTitle,
                                                  style: Styles.errorText,
                                                ),
                                                content: Text(
                                                  eventViewModel.errorMessages
                                                      .join(" "),
                                                  style: Styles.errorText,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(close),
                                                  )
                                                ],
                                              ));
                                    }
                                  } else {
                                    eventViewModel.removeFavouriteEvent(
                                        userModel, widget.eventModel.id);
                                    if (eventViewModel.errorMessages.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              successfulRemoveFromFavoritesMessage);
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                  errorDialogTitle,
                                                  style: Styles.errorText,
                                                ),
                                                content: Text(
                                                  eventViewModel.errorMessages
                                                      .join(" "),
                                                  style: Styles.errorText,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(close),
                                                  )
                                                ],
                                              ));
                                    }
                                  }
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                color: _isFavorite ? Colors.red : Colors.grey,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: MyButton(
                          participation,
                          () async {
                            await eventViewModel.addParticipation(
                                userModel.id, widget.eventModel);
                            if (eventViewModel.errorMessages.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: successfulParticipationMessage);
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    errorDialogTitle,
                                    style: Styles.errorText,
                                  ),
                                  content: Text(
                                    eventViewModel.errorMessages.join(" "),
                                    style: Styles.errorText,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(close),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: MyButton(
                          removeParticipation,
                          () async {
                            await eventViewModel.removeParticipation(
                                userModel.id, widget.eventModel);
                            if (eventViewModel.errorMessages.isEmpty) {
                              Fluttertoast.showToast(
                                  msg:
                                      successfulRemoveFromParticipationMessage);
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    errorDialogTitle,
                                    style: Styles.errorText,
                                  ),
                                  content: Text(
                                    eventViewModel.errorMessages.join(" "),
                                    style: Styles.errorText,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(close),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.eventModel.description),
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Text(loading);
          }
        },
      ),
    );
  }
}
