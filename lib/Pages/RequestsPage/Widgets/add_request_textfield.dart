import 'package:flutter/material.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class AddRequestTextField extends StatelessWidget {
  final String label;
  final TextInputType textInputType;
  final ValueChanged<String>? onChanged;
  final bool disable;

  const AddRequestTextField({
    required this.label,
    required this.textInputType,
    required this.onChanged,
    this.disable = false
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: getPropHeight(screenHeight, 26)),
      child: TextField(
        enabled: !disable,
        decoration: InputDecoration(
          labelText: "$label",
          labelStyle: TextStyle(
            fontSize: getPropWidth(screenWidth, 20),
            color: Color.fromRGBO(158, 158, 158, 1),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(208, 213, 216, 1),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(208, 213, 216, 1),
            ),
          ),
        ),
        keyboardType: textInputType,
        onChanged: onChanged,
      ),
    );
  }
}
