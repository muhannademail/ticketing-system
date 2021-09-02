import 'package:flutter/material.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextInputType? textInputType;
  final bool isEnabled;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const AuthTextField({
    required this.hintText,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    this.isEnabled = true,
    this.validator,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return TextFormField(
      enabled: isEnabled,
      obscureText: isPassword,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      keyboardType: textInputType,
      decoration: InputDecoration(
        filled: !isEnabled,
        fillColor: isEnabled ? Colors.white : Color.fromRGBO(158, 158, 158, 1),
        labelText: "$hintText",
        labelStyle: TextStyle(
          fontSize: getPropWidth(screenWidth, 18),
        ),
      ),
    );
  }
}
