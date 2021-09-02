import 'package:flutter/material.dart';
import 'package:ticketing_system/Services/responsive_service.dart';

import '../TicketsScreen.dart';

class RequestAppBar extends StatefulWidget {
  final Function(RequestType?) onChange;

  RequestAppBar(this.onChange);

  @override
  _RequestAppBarState createState() => _RequestAppBarState();
}

class _RequestAppBarState extends State<RequestAppBar> {
  final Map<RequestType, String> requestTypeText = {
    RequestType.Pending: "Pending Requests",
    RequestType.Resolved: "Resolved Requests",
  };

  RequestType selectedRequestType = RequestType.Pending;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButton<RequestType>(
          dropdownColor: Theme.of(context).primaryColor,
          iconEnabledColor: Colors.white,
          value: selectedRequestType,
          items: List<DropdownMenuItem<RequestType>>.generate(
            requestTypeText.length,
            (index) => DropdownMenuItem(
              value: requestTypeText.keys.elementAt(index),
              child: SizedBox(
                // width: getPropWidth(screenWidth, 180),
                child: Text(
                  "${requestTypeText.values.elementAt(index)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getPropWidth(screenWidth, 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          underline: SizedBox(height: 0),
          onChanged: (type) => {
            update(type)
          },
        ),
      ],
    );
  }

  update(RequestType? type) {
    setState(() => selectedRequestType = type ?? RequestType.Pending);
    widget.onChange(type);
  }
}
