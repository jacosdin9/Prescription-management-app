import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/addPrescription.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //show current patient id
          currentPatientID == "" ? Text("NO PATIENT SELECTED") : Text(currentPatientID),
        ],
      ),
    );
  }
}