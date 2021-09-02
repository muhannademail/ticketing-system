import 'package:flutter/material.dart';
import 'package:ticketing_system/Pages/AuthPage/Widgets/auth_body.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthBody(),
      ),
    );
  }
}
