import 'package:flutter/material.dart';
import 'package:ticketing_system/Models/setting.dart';
import 'package:ticketing_system/Services/database.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class SettingsBody extends StatefulWidget {
  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final settingId = 1;

  String serverLink = "";

  bool isLoading = false;

  final TextEditingController controller = TextEditingController();

  saveServerLink(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    _formKey.currentState!.save();

    try {
      int res = await DBProvider.db
          .insertSetting(Setting(id: settingId, serverLink: serverLink));

      if (settingId == res) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server Link Saved"),
          duration: Duration(seconds: 3),
        ));
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Error"),
            content: Text("Server Link Not Saved"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Ok"),
              ),
            ],
          ),
        );
      }
    } catch (err) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text("$err"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  getSetting() async {
    try {
      setState(() => isLoading = true);

      Setting? currentSetting = await DBProvider.db.getSetting();

      if (currentSetting == null) controller.text = "";

      controller.text = currentSetting!.serverLink;

      setState(() => isLoading = false);
    } catch (err) {
      controller.text = "";
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.symmetric(
              vertical: getPropHeight(screenHeight, 20),
              horizontal: getPropWidth(screenWidth, 18),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: "Server Link",
                      labelStyle: TextStyle(
                        fontSize: getPropWidth(screenWidth, 18),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "* This Field Is Required";

                      return null;
                    },
                    onSaved: (value) {
                      serverLink = value ?? "";
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: getPropHeight(screenHeight, 16),
                    ),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => saveServerLink(context),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: getPropWidth(screenWidth, 16),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(158, 158, 158, 1),
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                              vertical: getPropHeight(screenHeight, 12),
                              horizontal: getPropWidth(screenWidth, 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
