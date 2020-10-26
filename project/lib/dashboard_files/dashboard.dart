import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/objects/prescription.dart';
import 'package:project/prescriptions_files/addPrescription.dart';

Prescription test1 = Prescription(name: "test", dosage: 0.05, measurement: "mg", noOfReminders: 3, stock: 100);


class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //show current patient id
          currentPatientID == "" ? Text("NO PATIENT SELECTED") : Text(currentPatientID),

          currentPatientID != "" ?
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPrescription()),
              );
            },
            child: Text(
              "Add prescription",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ) :
              Text("SELECT A PATIENT TO VIEW THEIR PRESCRIPTIONS"),
        ],
      ),
    );
  }
}