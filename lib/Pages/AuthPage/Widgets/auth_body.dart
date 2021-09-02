import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketing_system/Helpers/constants.dart';
import 'package:ticketing_system/Models/UserModel.dart';
import 'package:ticketing_system/Models/api_response.dart';
import 'package:ticketing_system/Pages/AuthPage/Widgets/text_field.dart';
import 'package:ticketing_system/Pages/AuthPage/auth_page.dart';
import 'package:ticketing_system/Pages/AuthPage/forgot_password_page.dart';
import 'package:ticketing_system/Pages/RequestsPage/TicketsScreen.dart';
import 'package:ticketing_system/Providers/RegisterProvier.dart';
import 'package:ticketing_system/Repositories/UserRepository.dart';
import 'package:ticketing_system/Services/responsive_service.dart';
import 'package:http/http.dart' as http;

import 'app_bar.dart';
import 'auth_next_btn.dart';

enum AuthType { Login, Register }

class AuthBody extends StatefulWidget {
  @override
  _AuthBodyState createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  final GlobalKey<FormState> _form2Key = GlobalKey<FormState>();

  AuthType authType = AuthType.Login;

  bool isRemember = false;

  bool isNextPage = false;

  void changeAuthType() {
    setState(() => isNextPage = false);

    if (authType == AuthType.Login)
      setState(() => authType = AuthType.Register);
    else
      setState(() => authType = AuthType.Login);
  }

  nextBtnClicked(BuildContext context) async {
    if (authType == AuthType.Login) {
      loginUser();
    } else {
      if (!isNextPage) {
        if (!_form1Key.currentState!.validate()) return;

        setState(() => isNextPage = true);
      } else {
        if (!_form2Key.currentState!.validate()) return;

        registerUser();
      }
    }
  }

  registerUser() async {
    RegisterProvider registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(Constants.RegisterUrl));
    request.body = json.encode({
      "FirstName": registerProvider.registerMap["FirstName"],
      "LastName": registerProvider.registerMap["LastName"],
      "PhoneNumber": registerProvider.registerMap["Phone"],
      "UserName": registerProvider.registerMap["UserName"],
      "Password": registerProvider.registerMap["Password"],
      "Email": registerProvider.registerMap["Email"],
      "UserType": 0,
      "companyDto": {
        "Name": registerProvider.registerMap["Name"],
        "Branch": registerProvider.registerMap["Branch"],
        "City": registerProvider.registerMap["City"],
        "Region": registerProvider.registerMap["Region"],
        "Address": registerProvider.registerMap["Address"]
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    String data = await response.stream.bytesToString();

    ApiResponse apiResponse = ApiResponse.fromJson(json.decode(data));

    if (apiResponse.metaData.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please Login"),
        duration: Duration(seconds: 3),
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthPage()),
      );
    }
  }

  loginUser() async {
    Map map = Provider.of<RegisterProvider>(context, listen: false).registerMap;

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(Constants.LoginUrl));
    request.body = json.encode({
      "userName": map["UserName"],
      "password": map["Password"],
    });
    request.headers.addAll(headers);
    print(request.body);

    http.StreamedResponse response = await request.send();

    String data = await response.stream.bytesToString();
    print(data);

    ApiResponse apiResponse = ApiResponse.fromJson(json.decode(data));

    if (apiResponse.metaData.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Welcome: ${(apiResponse.data as dynamic)["userName"]}"),
        duration: Duration(seconds: 3),
      ));

      // Store user data
      await UserRepository.saveUserData(apiResponse);

      // Navigate to tickets screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RequestPage()),
      );

    } else if (apiResponse.metaData.statusCode == 400) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text("${apiResponse.metaData.message}"),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    RegisterProvider registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          AuthAppBar(
            title: authType == AuthType.Login ? "Register" : "Login",
            onPressed: changeAuthType,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: getPropHeight(screenHeight, 20),
              right: getPropWidth(screenWidth, 18),
              left: getPropWidth(screenWidth, 18),
            ),
            child: Stack(
              children: [
                Visibility(
                  visible: !isNextPage,
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
                      child: Form(
                        key: _form1Key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              authType == AuthType.Login ? "LOGIN" : "REGISTER",
                              style: TextStyle(
                                letterSpacing: 1.5,
                                color: Color.fromRGBO(0, 197, 214, 1),
                                fontSize: getPropWidth(screenWidth, 22),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: getPropHeight(screenHeight, 45)),
                            authType == AuthType.Register
                                ? AuthTextField(
                                    hintText: "Full Name",
                                    onChanged: (value) {
                                      if (value == null) return;
                                      var s = value.split(' ');
                                      registerProvider.saveInputs(
                                          "FirstName", "${s[0]}");
                                      registerProvider.saveInputs(
                                          "LastName", "${s[0]}");
                                    },
                                  )
                                : AuthTextField(
                                    hintText: "User Id",
                                    onChanged: (value) {
                                      if (value == null) return;
                                      registerProvider.saveInputs(
                                          "UserName", value);
                                    },
                                  ),
                            if (authType == AuthType.Register)
                              SizedBox(height: getPropHeight(screenHeight, 25)),
                            if (authType == AuthType.Register)
                              AuthTextField(
                                hintText: "User Id",
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "* This Field Required";

                                  return null;
                                },
                                onChanged: (value) {
                                  if (value == null) return;
                                  registerProvider.saveInputs(
                                      "UserName", value);
                                },
                              ),
                            if (authType == AuthType.Register)
                              SizedBox(height: getPropHeight(screenHeight, 25)),
                            if (authType == AuthType.Register)
                              AuthTextField(
                                hintText: "Email ID",
                                textInputType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  if (value == null) return;
                                  registerProvider.saveInputs("Email", value);
                                },
                              ),
                            SizedBox(height: getPropHeight(screenHeight, 25)),
                            AuthTextField(
                              hintText: "Password",
                              controller: passwordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "* This Field Required";

                                return null;
                              },
                              onChanged: (value) {
                                if (value == null) return;
                                registerProvider.saveInputs("Password", value);
                              },
                            ),
                            SizedBox(height: getPropHeight(screenHeight, 25)),
                            if (authType == AuthType.Register)
                              AuthTextField(
                                hintText: "Confirm Password",
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return "* This Field Required";

                                  if (value != passwordController.text)
                                    return "Password does not match";

                                  return null;
                                },
                                onChanged: (value) {
                                  if (value == null) return;
                                  registerProvider.saveInputs(
                                      "Password", value);
                                },
                              ),
                            SizedBox(height: getPropHeight(screenHeight, 14)),
                            if (authType == AuthType.Login)
                              SizedBox(height: getPropHeight(screenHeight, 6)),
                            if (authType == AuthType.Login)
                              CheckboxListTile(
                                value: isRemember,
                                onChanged: (value) =>
                                    setState(() => isRemember = value ?? false),
                                title: Text(
                                  "Remember Me",
                                  style: TextStyle(
                                    fontSize: getPropWidth(screenWidth, 16),
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                              ),
                            if (authType == AuthType.Login)
                              SizedBox(height: getPropHeight(screenHeight, 6)),
                            if (authType == AuthType.Login)
                              Align(
                                alignment: Alignment(1, 0),
                                child: TextButton(
                                  child: Text(
                                    "Forgot Password ?",
                                    style: TextStyle(
                                      fontSize: getPropWidth(screenWidth, 16),
                                    ),
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ForgotPasswordPage()),
                                  ),
                                ),
                              ),
                            authType == AuthType.Login
                                ? SizedBox(
                                    height: getPropHeight(screenHeight, 60))
                                : SizedBox(
                                    height: getPropHeight(screenHeight, 50)),
                            Align(
                              alignment: Alignment(1, 0),
                              child: AuthNextBtn(
                                  onPressed: () => nextBtnClicked(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isNextPage,
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
                      child: Form(
                        key: _form2Key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              authType == AuthType.Login ? "LOGIN" : "REGISTER",
                              style: TextStyle(
                                letterSpacing: 1.5,
                                color: Color.fromRGBO(0, 197, 214, 1),
                                fontSize: getPropWidth(screenWidth, 22),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: getPropHeight(screenHeight, 45)),
                            if (authType == AuthType.Register)
                              AuthTextField(
                                hintText: "Company Name",
                                onChanged: (value) {
                                  if (value == null) return;
                                  registerProvider.saveInputs("Name", value);
                                },
                              ),
                            if (authType == AuthType.Register)
                              SizedBox(height: getPropHeight(screenHeight, 25)),
                            if (authType == AuthType.Register)
                              AuthTextField(
                                hintText: "Branch Name",
                                onChanged: (value) {
                                  if (value == null) return;
                                  registerProvider.saveInputs("Branch", value);
                                },
                              ),
                            if (authType == AuthType.Register)
                              SizedBox(height: getPropHeight(screenHeight, 25)),
                            if (authType == AuthType.Register)
                              AuthTextField(
                                hintText: "Telephone",
                                textInputType: TextInputType.phone,
                                onChanged: (value) {
                                  if (value == null) return;
                                  registerProvider.saveInputs("Phone", value);
                                },
                              ),
                            SizedBox(height: getPropHeight(screenHeight, 25)),
                            AuthTextField(
                              hintText: "City",
                              onChanged: (value) {
                                if (value == null) return;
                                registerProvider.saveInputs("City", value);
                              },
                            ),
                            SizedBox(height: getPropHeight(screenHeight, 25)),
                            AuthTextField(
                              hintText: "Region",
                              onChanged: (value) {
                                if (value == null) return;
                                registerProvider.saveInputs("Region", value);
                              },
                            ),
                            SizedBox(height: getPropHeight(screenHeight, 14)),
                            authType == AuthType.Login
                                ? SizedBox(
                                    height: getPropHeight(screenHeight, 60))
                                : SizedBox(
                                    height: getPropHeight(screenHeight, 60)),
                            Align(
                              alignment: Alignment(1, 0),
                              child: AuthNextBtn(
                                  onPressed: () => nextBtnClicked(context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
