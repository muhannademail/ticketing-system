import 'package:flutter/material.dart';

import 'Widgets/settings_body.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SettingsBody(),
    );
  }
}
