import 'package:flutter/material.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

import 'Widgets/app_bar.dart';
import 'Widgets/auth_next_btn.dart';
import 'Widgets/text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isEmailEnabled = true;

  bool isCodeVisible = false;

  nextBtnClicked(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Verification"),
        content: Text("An Email With Verification Code Was Sent to your Email"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Ok"),
          ),
        ],
      ),
    );

    setState(() {
      isEmailEnabled = false;
      isCodeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthAppBar(
                title: "Forgot Password",
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: getPropHeight(screenHeight, 20),
                  right: getPropWidth(screenWidth, 18),
                  left: getPropWidth(screenWidth, 18),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(22),
                    ),
                  ),
                  shadowColor: Color.fromRGBO(240, 240, 240, 1),
                  elevation: 25,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getPropHeight(screenHeight, 20),
                      horizontal: getPropWidth(screenWidth, 18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "FORGOT PASSWORD",
                          style: TextStyle(
                            letterSpacing: 1.5,
                            color: Color.fromRGBO(0, 197, 214, 1),
                            fontSize: getPropWidth(screenWidth, 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: getPropHeight(screenHeight, 45)),
                        AuthTextField(
                          hintText: "User Name",
                          isEnabled: isEmailEnabled,
                        ),
                        SizedBox(height: getPropHeight(screenHeight, 25)),
                        AuthTextField(
                          hintText: "Email ID",
                          isEnabled: isEmailEnabled,
                        ),
                        SizedBox(height: getPropHeight(screenHeight, 25)),
                        Visibility(
                          visible: isCodeVisible,
                          child: AuthTextField(
                            hintText: "Code",
                            textInputType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: getPropHeight(screenHeight, 80)),
                        Align(
                          alignment: Alignment(1, 0),
                          child: AuthNextBtn(
                            onPressed: () async => await nextBtnClicked(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
