import 'package:flutter/material.dart';
import '../utils/styles.dart';

class DrawerList extends StatelessWidget {
  final String name;
  final Widget icon;
  final Function()? onTap;

  const DrawerList(this.name, this.icon, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: Styles.drawerText,
      ),
      leading: icon,
      onTap: onTap,
    );
  }
}
