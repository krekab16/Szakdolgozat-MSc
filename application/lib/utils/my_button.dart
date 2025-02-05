import 'package:application/utils/styles.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class MyButton extends StatelessWidget {
  final String reg;
  final Function() onPressed;

  const MyButton(this.reg, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: MyColors.lightBlueColor,
                padding: const EdgeInsets.all(5.0),
              ),
              child: Text(
                reg.toUpperCase(),
                style: Styles.buttonStyles,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
