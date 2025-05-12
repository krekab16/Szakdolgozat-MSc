import 'package:application/model/my_ticket_with_event_dto.dart';
import 'package:application/ui/ticket_screen_ui.dart';
import 'package:application/utils/my_button.dart';
import 'package:application/viewmodel/event_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/event_model.dart';
import '../model/user_model.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import 'package:rating_summary/rating_summary.dart';


class EventScreen extends StatefulWidget {
  final EventModel eventModel;

  const EventScreen(this.eventModel, {Key? key,}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isFavorite = false;
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);
    final userModel = Provider.of<UserModel>(context);
    return Scaffold(
      body: FutureBuilder<bool>(
        future: eventViewModel.getMyLikeForEvent(
            userModel.id, widget.eventModel.id, userModel),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            _isFavorite = snapshot.data ?? false;
            return ListView(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
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
                              // eventViewModel.updateUser(userModel);
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
                          ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                bool newFavoriteStatus = !_isFavorite;
                                if (newFavoriteStatus) {
                                  await eventViewModel.addLikeToEvent(userModel.id, widget.eventModel.id, userModel, widget.eventModel);
                                } else {
                                  await eventViewModel.removeLikeFromEvent(userModel.id, widget.eventModel.id, userModel, widget.eventModel);
                                }
                                setState(() {
                                  _isFavorite = newFavoriteStatus;
                                });
                                if (eventViewModel.errorMessages.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: newFavoriteStatus ? successfulAddToFavoritesMessage : successfulRemoveFromFavoritesMessage,
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(errorDialogTitle, style: Styles.errorText),
                                      content: Text(eventViewModel.errorMessages.join(" "), style: Styles.errorText),
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
                              child: Icon(
                                Icons.favorite,
                                color: _isFavorite ? Colors.red : Colors.grey,
                                size: 35,
                              ),
                            ),
                            FutureBuilder<bool>(
                              future: eventViewModel.getParticipationStatusForUser(userModel.id, widget.eventModel.id),
                              builder: (context, participationSnapshot) {
                                bool isParticipated = participationSnapshot.data ?? false;
                                if (!isParticipated) {
                                  return Text(mustParticipateText);
                                }
                                return FutureBuilder<double>(
                                  future: eventViewModel.getMyRatingValueForEvent(userModel.id, widget.eventModel.id, userModel),
                                  builder: (context,  AsyncSnapshot<double> ratingSnapshot) {
                                    double initialRating = ratingSnapshot.data ?? 0.0;
                                    return RatingBar.builder(
                                      minRating: 1,
                                      maxRating: 5,
                                      initialRating: initialRating,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (newRating) async {
                                        setState(() {
                                          initialRating = newRating;
                                        });
                                        await eventViewModel.addRatingToEvent(userModel.id, widget.eventModel.id, newRating, userModel, widget.eventModel);
                                        if (eventViewModel.errorMessages.isEmpty) {
                                          Fluttertoast.showToast(msg: successfulRated);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: Text(errorDialogTitle, style: Styles.errorText),
                                              content: Text(eventViewModel.errorMessages.join(" "), style: Styles.errorText),
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
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                        future: eventViewModel.getRatingValuesForEvent(widget.eventModel.id, widget.eventModel),
                        builder: (context, AsyncSnapshot<Map<String, dynamic>> ratingSnapshot) {
                          if (ratingSnapshot.hasData) {
                            var ratingData = ratingSnapshot.data;
                            double averageRating = ratingData?['average'] ?? 0.0;
                            int counter = ratingData?['counter'] ?? 0;
                            int counterFiveStars = ratingData?['counterFiveStars'] ?? 0;
                            int counterFourStars = ratingData?['counterFourStars'] ?? 0;
                            int counterThreeStars = ratingData?['counterThreeStars'] ?? 0;
                            int counterTwoStars = ratingData?['counterTwoStars'] ?? 0;
                            int counterOneStars = ratingData?['counterOneStars'] ?? 0;
                            return Column(
                              children: [
                                RatingSummary(
                                  counter: counter,
                                  average: averageRating,
                                  showAverage: true,
                                  counterFiveStars: counterFiveStars,
                                  counterFourStars: counterFourStars,
                                  counterThreeStars: counterThreeStars,
                                  counterTwoStars: counterTwoStars,
                                  counterOneStars: counterOneStars,
                                ),
                                SizedBox(height: 8),
                              ],
                            );
                          } else {
                            return Text(loading);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: MyButton(
                          participation,
                              () async {
                            await eventViewModel.addParticipation(
                                userModel.id, widget.eventModel);
                            if (eventViewModel.errorMessages.isEmpty) {
                              Fluttertoast.showToast(msg: successfulParticipationMessage);
                              MyTicketWithEventDTO? myTicketWithEventDTO = await eventViewModel.addAndGetTicketData(userModel.id, widget.eventModel);
                              if (myTicketWithEventDTO != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketScreen(
                                        myTicketWithEventDTO
                                    ),
                                  ),
                                );
                              }
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
