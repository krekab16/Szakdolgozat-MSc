import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import '../utils/colors.dart';
import '../utils/drawer_list.dart';
import '../utils/styles.dart';
import '../utils/text_strings.dart';
import '../viewmodel/menu_view_model.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    final menuViewModel = Provider.of<MenuViewModel>(context);
    final userModel = Provider.of<UserModel>(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: MyColors.lightBlueColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        DateFormat(dateFormat).format(DateTime.now()),
                        textAlign: TextAlign.left,
                        style: Styles.dateTimeText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        menu,
                        textAlign: TextAlign.left,
                        style: Styles.menuTextStyles,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          DrawerList(home, const Icon(Icons.home),
              () => menuViewModel.navigateToHome(context)),
          DrawerList(favourites, const Icon(Icons.favorite),
              () => menuViewModel.navigateToFavourites(context,userModel.id)),
          DrawerList(profile, const Icon(Icons.account_circle),
              () => menuViewModel.navigateToProfile(context, userModel.id)),
          if (userModel.isOrganizer)...[
            DrawerList(participatedEvents, const Icon(Icons.event_rounded),
                () => menuViewModel.navigateToParticipatedEvent(context, userModel.id)),
            DrawerList(newEvent, const Icon(Icons.fiber_new),
                () => menuViewModel.navigateToNewEvent(context)),
            DrawerList(created, const Icon(Icons.create),
                () => menuViewModel.navigateToCreatedEvent(context, userModel.id)),
          ],
          DrawerList(logout, const Icon(Icons.logout),
              () => menuViewModel.logOut(context)),
        ],
      ),
    );
  }
}
