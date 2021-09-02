import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ticketing_system/Helpers/constants.dart';
import 'package:ticketing_system/Models/TicketModel.dart';
import 'package:ticketing_system/Models/api_response.dart';
import 'package:ticketing_system/Pages/RequestsPage/Widgets/request_app_bar.dart';
import 'package:ticketing_system/Pages/RequestsPage/Widgets/request_item.dart';
import 'package:ticketing_system/Pages/RequestsPage/AddTicketScreen.dart';
import 'package:ticketing_system/Repositories/UserRepository.dart';
import 'package:ticketing_system/Services/responsive_service.dart';
import 'package:ticketing_system/Widgets/my_drawer.dart';
import 'package:http/http.dart' as http;

enum RequestType { Pending, Resolved }

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  bool isSearch = false;
  bool isAdmin = false;
  RequestType filterType = RequestType.Pending;
  List<TicketModel> tickets  = [];

  search() {
    setState(() => isSearch = !isSearch);
  }

  @override
  void initState() {
    super.initState();
    initUiState();
    fetchTickets(filterType);
  }

  initUiState() async {
    var user = await UserRepository.getUserData();
    setState(() => isAdmin = user?.userType != 0);
  }

  Future<void> refreshTickets() async {
    await fetchTickets(filterType);
  }

  Future<void> fetchTickets(RequestType filterType) async {
    this.filterType = filterType;
    var user = await UserRepository.getUserData();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${user?.token}'
    };

    // Request
    var filter = filterType == RequestType.Pending ? 0 : 1;

    var request = http.Request('GET', Uri.parse('${Constants.TicketsUrl}?TicketStatus=$filter'));
    print(request.url);
    request.headers.addAll(headers);

    // waiting for response
    http.StreamedResponse response = await request.send();

    // Response
    String data = await response.stream.bytesToString();
    print('$data');

    // Parsing response
    ApiResponse apiResponse = ApiResponse.fromJson(json.decode(data));
    if (apiResponse.metaData.statusCode == 200) {
      print('Tickets\n${apiResponse.data.toString()}');
      List<TicketModel> tickets = [];
      (apiResponse.data! as List<dynamic>).forEach((ticket) => {
        tickets.add(TicketModel.fromJson(ticket))
      });

      setState(() {
        this.tickets = tickets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(224, 224, 224, 1),
      appBar: AppBar(
        title: !isSearch
            ? RequestAppBar((filter) => {
              fetchTickets(filter!)
        })
            : TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(208, 213, 216, 1),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(208, 213, 216, 1),
                    ),
                  ),
                  hintText: "Search...",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
        actions: [
          IconButton(
            tooltip: "Search",
            onPressed: search,
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            tooltip: "Notifications",
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshTickets,
        child: ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                RequestItem(tickets[index], index),
                Divider(thickness: 0.4),
              ],
            );
        })
      ),
      drawer: MyDrawer(),
      floatingActionButton: Visibility(
        visible: !isAdmin,
        child: FloatingActionButton(
          tooltip: "Add Request",
          backgroundColor: Color.fromRGBO(66, 66, 66, 1),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRequestPage()),
          ),
          child: Icon(
            Icons.add,
            size: getPropWidth(screenWidth, 26),
          ),
        ),
      ),
    );
  }
}
