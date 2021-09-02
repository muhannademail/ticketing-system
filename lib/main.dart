import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/Models/UserModel.dart';
import 'package:ticketing_system/Models/setting.dart';
import 'package:ticketing_system/Pages/AuthPage/auth_page.dart';
import 'package:ticketing_system/Pages/RequestsPage/TicketsScreen.dart';
import 'package:ticketing_system/Providers/RegisterProvier.dart';
import 'package:ticketing_system/Providers/TicketProvider.dart';
import 'package:ticketing_system/Providers/UserProvider.dart';
import 'package:ticketing_system/Repositories/UserRepository.dart';
import 'package:ticketing_system/Services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBProvider.db.initDB();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterProvider>(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<TicketProvider>(
          create: (_) => TicketProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Gigabyte Ltd. Ticketing System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(48, 48, 48, 1),
        ),
        home: FutureBuilder<UserModel?>(
          future: UserRepository.getUserData(),
          builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
            if(snapshot.data == null) {
              return AuthPage();
            }
            else {
              print(snapshot.data?.firstName);
              return RequestPage();
            }
          },

        ),
      ),
    );
  }
}
