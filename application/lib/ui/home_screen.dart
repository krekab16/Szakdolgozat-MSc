import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/home_view_model.dart';
import 'menu_ui.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.lightBlueColor,
        title: Text(
          eventHome,
          style: Styles.textStyles,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              homeViewModel.navigateToMapScreen(context);
            },
          ),
        ],
      ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (homeViewModel.errorMessages.isNotEmpty)...[
                Text(homeViewModel.errorMessages.join(' ')),
              ] else ...[
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                  ),
                  items: (homeViewModel.recommendedEvents.events.isNotEmpty
                      ? homeViewModel.recommendedEvents.events
                      : homeViewModel.homeModel.events)
                      .map((event) {
                    return Builder(
                      builder: (BuildContext context) {
                        return EventBox(event);
                      },
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: homeViewModel.homeModel.events.length,
                    itemBuilder: (context, index) {
                      return EventBox(homeViewModel.homeModel.events[index]);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        drawer: const Menu(),
    );
  }
}
