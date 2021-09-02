import 'package:flutter/material.dart';
import 'package:ticketing_system/Pages/AuthPage/auth_page.dart';
import 'package:ticketing_system/Pages/RequestsPage/AddTicketScreen.dart';
import 'package:ticketing_system/Pages/RequestsPage/TicketsScreen.dart';
import 'package:ticketing_system/Pages/SettingsPage/settings_page.dart';
import 'package:ticketing_system/Repositories/UserRepository.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    logout() async {
      await UserRepository.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthPage()),
      );
    }

    return Drawer(
      child: SafeArea(
        child: Container(
          color: Color.fromRGBO(233, 233, 233, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDrawerHeader(context, screenHeight, screenWidth),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getPropHeight(screenHeight, 14)),
                child: Column(
                  children: [
                    buildDrawerItem(
                      screenWidth,
                      title: "Requests",
                      icon: Icons.request_page_outlined,
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => RequestPage()),
                      ),
                    ),
                    buildDrawerItem(
                      screenWidth,
                      title: "Add Request",
                      icon: Icons.post_add_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddRequestPage()),
                      ),
                    ),
                    SizedBox(height: getPropHeight(screenHeight, 15)),
                    Divider(thickness: 0.8),
                    buildDrawerItem(
                      screenWidth,
                      title: "Settings",
                      icon: Icons.settings,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsPage()),
                      ),
                    ),
                    buildDrawerItem(
                      screenWidth,
                      title: "Contact",
                      icon: Icons.contact_support,
                    ),
                    buildDrawerItem(
                      screenWidth,
                      title: "Logout",
                      icon: Icons.logout,
                      onTap: () => {
                        logout()
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItem(
    double screenWidth, {
    required String title,
    required IconData icon,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: getPropWidth(screenWidth, 30),
      title: Text(
        "$title",
        style: TextStyle(
          fontSize: getPropWidth(screenWidth, 16),
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Icon(
        icon,
        color: Color.fromRGBO(158, 158, 158, 1),
        size: getPropWidth(screenWidth, 30),
      ),
    );
  }

  Widget buildDrawerHeader(
    BuildContext context,
    double screenHeight,
    double screenWidth,
  ) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: screenHeight * 0.23,
      padding: EdgeInsets.symmetric(
        vertical: getPropHeight(screenHeight, 20),
        horizontal: getPropWidth(screenWidth, 18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(158, 158, 158, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            width: getPropWidth(screenWidth, 85),
            height: getPropHeight(screenHeight, 85),
            child: Icon(
              Icons.person,
              size: getPropWidth(screenWidth, 30),
              color: Color.fromRGBO(97, 97, 97, 1),
            ),
          ),
          SizedBox(height: getPropHeight(screenHeight, 20)),
          Text(
            "Gigabyteltd",
            style: TextStyle(
              color: Colors.white,
              fontSize: getPropWidth(screenWidth, 17),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: getPropHeight(screenHeight, 5)),
          Text(
            "servis@gigabyteltd.com",
            style: TextStyle(
              color: Colors.white,
              fontSize: getPropWidth(screenWidth, 15),
            ),
          ),
        ],
      ),
    );
  }
}
