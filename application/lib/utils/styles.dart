import 'package:flutter/material.dart';
import 'colors.dart';

class Styles {
  static const String handleeFont = 'Handlee';
  static const String robotoFont = 'Roboto';

  static const TextStyle welcomeApplicationNameStyle = TextStyle(
    fontFamily: handleeFont,
    fontSize: 60,
    color: MyColors.darkBlueColor,
  );

  static const TextStyle welcomeTitleStyles = TextStyle(
    fontFamily: robotoFont,
    fontSize: 40,
    color: MyColors.textColor,
  );

  static const TextStyle welcomeSubTitleStyles = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    color: MyColors.textColor,
  );

  static const TextStyle buttonStyles = TextStyle(
    fontFamily: robotoFont,
    fontSize: 17,
    color: MyColors.textColor,
  );

  static const TextStyle textStyles = TextStyle(
    fontFamily: robotoFont,
    fontSize: 18,
    color: MyColors.textColor,
  );

  static const TextStyle errorText = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    color: Colors.red,
  );

  static const TextStyle eventBoxText = TextStyle(
    fontFamily: robotoFont,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    decoration: TextDecoration.underline,
  );

  static const TextStyle eventTitleStyle = TextStyle(
    fontFamily: robotoFont,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    decoration: TextDecoration.underline,
  );

  static const TextStyle eventCategoryStyle = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle eventAddressStyle = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    color: MyColors.textColor,
  );

  static const TextStyle eventDateStyle = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    color: MyColors.textColor,
  );

  static const TextStyle eventDescriptionStyle = TextStyle(
    fontFamily: robotoFont,
    fontSize: 18,
    color: MyColors.textColor,
  );

  static const TextStyle menuTextStyles = TextStyle(
    fontFamily: robotoFont,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: MyColors.darkBlueColor,
  );

  static const TextStyle drawerText = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    color: MyColors.darkBlueColor,
  );

  static const TextStyle dateTimeText = TextStyle(
    fontFamily: robotoFont,
    fontSize: 20,
    color: MyColors.darkBlueColor,
  );
}
