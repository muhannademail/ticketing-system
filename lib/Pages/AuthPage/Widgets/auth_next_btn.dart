import 'package:flutter/material.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class AuthNextBtn extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuthNextBtn({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: getPropWidth(screenWidth, 60),
      height: getPropHeight(screenHeight, 60),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color.fromRGBO(158, 158, 158, 1),
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward,
            size: getPropWidth(screenWidth, 30),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
