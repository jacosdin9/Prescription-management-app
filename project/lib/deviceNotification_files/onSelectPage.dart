import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';

class OnSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("On select page"),
        ),
        body: Column(
          children: [
            Text("hello"),

            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red),
              ),
              padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainArea(recentIndex)),
                );
              },
              child: Text(
                "BACK",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



}