import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DevNotificationPage extends StatelessWidget{
  final String name;
  final String description;

  DevNotificationPage(this.name, this.description);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Notification Selected"),
        ),
        body: Column(
          children: [
            Text("NOTIFICATION SELECTED"),
            SizedBox(height: 20),
            Text(name + ": " + description),
          ],
        )
      )
    );
  }

}