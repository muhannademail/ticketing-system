import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticketing_system/Helpers/constants.dart';
import 'package:ticketing_system/Models/TicketModel.dart';
import 'package:ticketing_system/Models/api_response.dart';
import 'package:ticketing_system/Repositories/UserRepository.dart';
import 'package:ticketing_system/Services/responsive_service.dart';
import 'package:http/http.dart' as http;

import 'Widgets/add_request_textfield.dart';

class RequestDetailsPage extends StatefulWidget {
  final TicketModel ticket;

  const RequestDetailsPage({
    required this.ticket
  });

  @override
  _RequestDetailsPageState createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  bool isExpanded = false;
  bool isAdmin = false;
  String technicianGrade = '';
  String assignment = '';

  @override
  void initState() {
    super.initState();
    initUiState();
  }

  initUiState() async {
    var user = await UserRepository.getUserData();
    setState(() => isAdmin = user?.userType != 0);
  }

  deleteTicket() async {
    // RegisterProvider registerProvider =
    // Provider.of<RegisterProvider>(context, listen: false);
    var user = await UserRepository.getUserData();
    var token = user?.token;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    // Sending request
    var response  = await http.delete(Uri.parse('${Constants.TicketsUrl}/${widget.ticket.id}'), headers: headers);
    print("url: ${Constants.TicketsUrl}/${widget.ticket.id}')");

    print(response.statusCode);
    if(response.statusCode == 200) {
      // Receiving response
      print(response.body);

      // Parsing response
      ApiResponse apiResponse = ApiResponse.fromJson(json.decode(response.body));
      // handling response
      if (apiResponse.metaData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiResponse.metaData.message),
          duration: Duration(seconds: 3),
        ));

        // Close current screen
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong, Please try again.'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  resolveTicket() async {
    // RegisterProvider registerProvider =
    // Provider.of<RegisterProvider>(context, listen: false);
    var user = await UserRepository.getUserData();
    var token = user?.token;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    if(technicianGrade.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please insert Technician grade'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    if(assignment.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please insert assignment'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    var body = jsonEncode(<String, String>{
      'technicanGrade': technicianGrade,
      'assignment': assignment
    });

    // Sending request
    var response  = await http.put(Uri.parse('${Constants.TicketsUrl}/${widget.ticket.id}'), headers: headers, body: body);
    print("url: ${Constants.TicketsUrl}/${widget.ticket.id}");

    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200) {
      // Receiving response
      print(response.body);

      // Parsing response
      ApiResponse apiResponse = ApiResponse.fromJson(json.decode(response.body));
      // handling response
      if (apiResponse.metaData.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(apiResponse.metaData.message),
          duration: Duration(seconds: 3),
        ));

        // Close current screen
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong, Please try again.'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.ticket.title}"),
        actions: [
          Visibility(
            visible: isAdmin,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: getPropHeight(screenHeight, 10),
            horizontal: getPropHeight(screenHeight, 10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${widget.ticket.title}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getPropWidth(screenWidth, 20),
                      ),
                    ),
                  ),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: getPropWidth(screenWidth, 18),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${widget.ticket.description}',
                    style: TextStyle(
                      fontSize: getPropWidth(screenWidth, 14),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.16),


                  Visibility(
                    visible: widget.ticket.status == 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: AddRequestTextField(
                        label: "Technician grade",
                        disable: !isAdmin,
                        textInputType: TextInputType.phone,
                        onChanged: (text) => {
                          technicianGrade = text
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: widget.ticket.status == 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Technician grade:',
                          style: TextStyle(
                            fontSize: getPropWidth(screenWidth, 18),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.ticket.technicianGrade}',
                          style: TextStyle(
                              fontSize: getPropWidth(screenWidth, 14),
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ),



                  Visibility(
                    visible: widget.ticket.status == 0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10,0,10,10),
                      child: AddRequestTextField(
                        label: "Assignment",
                        disable: !isAdmin,
                        textInputType: TextInputType.phone,
                        onChanged: (text) => {
                          assignment = text
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: widget.ticket.status == 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Assignment:',
                          style: TextStyle(
                            fontSize: getPropWidth(screenWidth, 18),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.ticket.assignment}',
                          style: TextStyle(
                              fontSize: getPropWidth(screenWidth, 14),
                              fontWeight: FontWeight.w500,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: false,
                    child: ExpansionTile(
                      onExpansionChanged: (val) => setState(() => isExpanded = val),
                      textColor: Colors.black,
                      collapsedTextColor: Color.fromRGBO(158, 158, 158, 1),
                      backgroundColor: Color.fromRGBO(224, 224, 224, 1),
                      title: Container(),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Technician",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: getPropWidth(screenWidth, 18),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Color.fromRGBO(158, 158, 158, 1),
                            size: getPropWidth(screenWidth, 30),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: getPropHeight(screenHeight, 10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Technician Appointed",
                                style: TextStyle(
                                  fontSize: getPropWidth(screenWidth, 18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "TechnicianID: 1",
                                style: TextStyle(
                                  fontSize: getPropWidth(screenWidth, 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: isAdmin && widget.ticket.status == 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                              ),
                              onPressed: () => resolveTicket(),
                              child: Text('RESOLVE TICKET'),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                              ),
                              onPressed: () => deleteTicket(),
                              child: Text('DELETE TICKET'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
