import 'package:flutter/material.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class AuthAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const AuthAppBar({
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getPropWidth(screenWidth, 10),
        vertical: getPropHeight(screenHeight, 10),
      ),
      color: Colors.white,
      width: double.infinity,
      child: Align(
        alignment: Alignment(1, 0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            "$title",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Color.fromRGBO(0, 197, 214, 1),
              fontSize: getPropWidth(screenWidth, 22),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
