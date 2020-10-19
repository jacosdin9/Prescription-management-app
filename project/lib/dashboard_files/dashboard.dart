import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/dashboard_files/addPrescription.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/objects/prescription.dart';

Prescription test1 = Prescription(name: "test", dosage: 0.05, measurement: "mg", noOfReminders: 3, stock: 100);


class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPrescription()),
            );
          },
          child: Text("Add prescription"),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}