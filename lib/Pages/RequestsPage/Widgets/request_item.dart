import 'package:flutter/material.dart';
import 'package:ticketing_system/Models/TicketModel.dart';
import 'package:ticketing_system/Pages/RequestsPage/TicketDetailsScreen.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

class RequestItem extends StatefulWidget {
  final TicketModel ticket;
  final int index;

  RequestItem(this.ticket, this.index) {}

  @override
  _RequestItemState createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {
  final Color checkColor = Color.fromRGBO(40, 180, 99, 1);

  final IconData checkIcon = Icons.check_circle_outline;

  final Color unCheckColor = Color.fromRGBO(204, 0, 0, 1);

  final IconData unCheckIcon = Icons.access_time;

  bool isCheckBoxChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getPropHeight(screenHeight, 10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: getPropWidth(screenWidth, 16),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Checkbox(
            onChanged: (val) =>
                setState(() => isCheckBoxChecked = val ?? false),
            value: isCheckBoxChecked,
          ),
          SizedBox(width: getPropWidth(screenWidth, 14)),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RequestDetailsPage(
                    ticket: widget.ticket,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "#${widget.index+1}",
                        style: TextStyle(
                          color: Color.fromRGBO(189, 189, 189, 1),
                          fontSize: getPropWidth(screenWidth, 18),
                        ),
                      ),
                      Text(
                        '${widget.ticket.created}',
                        style: TextStyle(
                          fontSize: getPropWidth(screenWidth, 18),
                          color: Color.fromRGBO(34, 34, 34, 1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getPropHeight(screenHeight, 8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.ticket.title}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getPropWidth(screenWidth, 18),
                        ),
                      ),
                      Visibility(
                        visible: widget.ticket.status != 0,
                        child: Icon(
                          checkIcon,
                          color: checkColor,
                        ),)
                    ],
                  ),
                  SizedBox(height: getPropHeight(screenHeight, 10)),
                  Row(
                    children: [
                      Text(
                        "${widget.ticket.issuerName} • ${widget.ticket.companyName}",
                        style: TextStyle(
                          fontSize: getPropWidth(screenWidth, 14),
                          color: Color.fromRGBO(189, 189, 189, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
