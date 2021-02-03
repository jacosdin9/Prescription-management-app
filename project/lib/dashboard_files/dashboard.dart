import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/patient_files/changeUser.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    recentIndex = 1;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //show current patient id
          currentPatientID == "" ? Text("NO PATIENT SELECTED") : Text(currentPatientID),

          //LOCAL NOTIFICATIONS TESTING
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            onPressed: () async {
              print(await checkIfNameExists("hi"));
              final List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
              for(var p in pendingNotificationRequests){
                print(p.id);
              }
            },
            child: Text(
              "Local notification test",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),

          // //TEST -----------------------------------------
          // //LOCAL NOTIFICATIONS TESTING
          // RaisedButton(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(18.0),
          //     side: BorderSide(color: Colors.red),
          //   ),
          //   padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          //   onPressed: () async {
          //
          //     flutterLocalNotificationsPlugin.cancelAll();
          //
          //   },
          //   child: Text(
          //     "create test notification",
          //     style: TextStyle(
          //       fontSize: 20,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}