import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';

class PrescriptionPopup extends StatelessWidget{

  String id;
  String name;
  double dosage;
  String measurement;
  int noOfReminders;
  double stock;

  PrescriptionPopup(this.id, this.name, this.dosage, this.measurement, this.noOfReminders, this.stock);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: Container(
        width: 260.0,
        height: 230.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // dialog top
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'helvetica_neue_light',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: new EdgeInsets.symmetric(vertical: 10.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff),
            ),
            // dialog centre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Dosage: " + dosage.toString() + measurement),
                  Text("No. of reminders: " + noOfReminders.toString()),
                  Text("Stock remaining: " + stock.toString()),
                ],
              ),
              flex: 2,
            ),

            // dialog bottom
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
                onPressed: () {
                  FirebasePage().deletePrescription(id);
                  Navigator.pop(context);
                },
                child: Text(
                  "Delete prescription",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}