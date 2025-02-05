import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PasswordInputBox extends StatelessWidget {
  final Widget fieldIcon;
  final String fieldText;
  final dynamic Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool passwordVisible;
  final IconButton suffixIcon;

  const PasswordInputBox(this.fieldIcon, this.fieldText, this.onChanged, this.validator, this.passwordVisible, this.suffixIcon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.name,
        onChanged: onChanged,
        validator: validator,
        obscureText: passwordVisible,
        decoration: InputDecoration(
          prefixIcon: fieldIcon,
          suffixIcon: suffixIcon,
          label: Text(
            fieldText,
            style: const TextStyle(
              color: Color(0xFF787878),
            ),
          ),
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: MyColors.textColor),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: MyColors.darkBlueColor),
          ),
        ),
      ),
    );

  }
}
