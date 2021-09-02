import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketing_system/Helpers/constants.dart';
import 'package:ticketing_system/Models/api_response.dart';
import 'package:ticketing_system/Pages/RequestsPage/Widgets/add_request_textfield.dart';
import 'package:ticketing_system/Providers/TicketProvider.dart';
import 'package:ticketing_system/Repositories/UserRepository.dart';
import 'package:ticketing_system/Services/responsive_service.dart';
import 'package:http/http.dart' as http;

enum RequestLevel { Low, Medium, High }
enum AddRequestType { Price, Job, Project, Demo }

class AddRequestPage extends StatefulWidget {
  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  var selectedRequestLevel;
  var selectedAddRequestType;

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result == null)
      return;

    print(result.files.single.path);
    print(result.files.single.size / 1024 / 1024);

    print("< 15 MB: ${result.files.single.size / 1024 / 1024 < 15}");

    TicketProvider ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    if(result.files.single.path != null) {
      ticketProvider.ticketMap['file'] = result.files.single.path;
    }
  }


  // Post ticket
  postTicket() async  {
    TicketProvider ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    var map = ticketProvider.ticketMap;

    // Collecting data
    var user = await UserRepository.getUserData();
    var token = user?.token;
    var issuerId = user?.id;
    var title = map['title'];
    var phone = map['phone'];
    var email = map['email'];
    var description = map['description'];
    var file = map['file'];
    var urgency = selectedRequestLevel.index;
    var type = selectedAddRequestType.index;

    print("token: ${user?.token}");
    print("userId: ${user?.id}");
    print("Title: $title");
    print("Phone: $phone");
    print("Email: $email");
    print("Description: $description");
    print("file: $file");
    print('urgency: ${selectedRequestLevel.index}');
    print('type: ${selectedAddRequestType.index}');

    // Shaping request
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest('POST', Uri.parse(Constants.TicketsUrl));
    // Multipart
    request.files.add(
        http.MultipartFile(
            'picture',
            File(file).readAsBytes().asStream(),
            File(file).lengthSync(),
            filename: file.split("/").last
        )
    );

    // Fields
    request.fields['Title'] = title.toString();
    request.fields['Type'] = type.toString();
    request.fields['Urgency'] = urgency.toString();
    request.fields['Description'] = description;

    // Headers
    request.headers.addAll(headers);
    print(request.fields);

    // Sending request
    http.StreamedResponse response = await request.send();
    // Getting response as a string
    String data = await response.stream.bytesToString();
    print(data);

    // Parsing response
    ApiResponse apiResponse = ApiResponse.fromJson(json.decode(data));

    // Handling response
    if (apiResponse.metaData.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(apiResponse.metaData.message),
        duration: Duration(seconds: 3),
      ));

      // Close
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please try again, something went wrong.'),
        duration: Duration(seconds: 3),
      ));
    }
    // Type integer($int32)
    // Urgency integer($int32)
    // Description string
    // File string($binary)
    // IssuerId string($uuid)

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TicketProvider ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Color.fromRGBO(224, 224, 224, 1),
      appBar: AppBar(
        title: Text("Add Request"),
        actions: [
          IconButton(
            tooltip: "Attach File",
            onPressed: uploadFile,
            icon: Icon(Icons.attach_file),
          ),
          IconButton(
            tooltip: "Save",
            onPressed: () {
              postTicket();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getPropHeight(screenHeight, 16),
            horizontal: getPropHeight(screenHeight, 22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<RequestLevel>(
                hint: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Select Urgency Level",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                dropdownColor: Theme.of(context).primaryColor,
                iconEnabledColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  fontSize: getPropWidth(screenWidth, 20),
                  color: Color.fromRGBO(158, 158, 158, 1),
                ),
                value: selectedRequestLevel,
                items: List<DropdownMenuItem<RequestLevel>>.generate(
                  RequestLevel.values.length,
                  (index) => DropdownMenuItem(
                    value: RequestLevel.values[index],
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: Text(
                        "${RequestLevel.values[index].toString().split("RequestLevel.")[1]}",
                        style: TextStyle(
                          color: Color.fromRGBO(158, 158, 158, 1),
                          fontSize: getPropWidth(screenWidth, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (type) {
                  setState(() => selectedRequestLevel = type);
                },
                underline: SizedBox(height: 5),
              ),
              SizedBox(height: getPropHeight(screenHeight, 18)),
              AddRequestTextField(
                label: "Title",
                textInputType: TextInputType.text,
                onChanged: (text) => {
                  ticketProvider.ticketMap['title'] = text
                },
              ),
              AddRequestTextField(
                label: "Phone",
                disable: true,
                textInputType: TextInputType.phone,
                onChanged: (text) => {
                  ticketProvider.ticketMap['phone'] = text
                },
              ),
              AddRequestTextField(
                label: "E-Mail",
                disable: true,
                textInputType: TextInputType.emailAddress,
                onChanged: (text) => {
                  ticketProvider.ticketMap['email'] = text
                },
              ),
              DropdownButton<AddRequestType>(
                hint: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Select Type",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                dropdownColor: Theme.of(context).primaryColor,
                iconEnabledColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  fontSize: getPropWidth(screenWidth, 20),
                  color: Color.fromRGBO(158, 158, 158, 1),
                ),
                value: selectedAddRequestType,
                items: List<DropdownMenuItem<AddRequestType>>.generate(
                  AddRequestType.values.length,
                  (index) => DropdownMenuItem(
                    value: AddRequestType.values[index],
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: Text(
                        "${AddRequestType.values[index].toString().split("AddRequestType.")[1]}",
                        style: TextStyle(
                          color: Color.fromRGBO(158, 158, 158, 1),
                          fontSize: getPropWidth(screenWidth, 16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                onChanged: (type) {
                  setState(() => selectedAddRequestType = type);
                },
                underline: SizedBox(height: 5),
              ),
              SizedBox(height: getPropHeight(screenHeight, 18)),
              AddRequestTextField(
                label: "Description",
                textInputType: TextInputType.text,
                onChanged: (text) => {
                  ticketProvider.ticketMap['description'] = text
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
