import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/deviceNotification_files/deviceNotifications.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/patient_files/changeUser.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //show current patient id
          currentPatientID == "" ? Text("NO PATIENT SELECTED") : Text(currentPatientID),

          currentPatientID == "" ?
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeUserPage()),
              );
            },
            child: Text(
              "Select a patient",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ) :
              SizedBox(height: 0),

          //LOCAL NOTIFICATIONS TESTING
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => DeviceNotifications("name", "description", DateTime.now()),
                ),
              );
            },
            child: Text(
              "Local notification test",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}