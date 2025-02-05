import 'package:application/utils/event_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/home_view_model.dart';
import 'menu_ui.dart';

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
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                  children: [
                if (homeViewModel.errorMessages.isNotEmpty)...[
                  Text(homeViewModel.errorMessages.join(' ')),
                ] else ...[
                  Column(
                    children: homeViewModel.homeModel.events
                        .map((event) => EventBox(event))
                        .toList(),
                  )
                ]
              ]),
            ),
          ],
        ),
      ),
      drawer: const Menu(),
    );
  }
}
