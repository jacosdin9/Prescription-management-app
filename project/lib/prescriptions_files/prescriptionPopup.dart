import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/prescriptions_files/editPrescription.dart';
import 'package:project/prescriptions_files/prescriptionClass.dart';

class PrescriptionPopup extends StatelessWidget{

  String id;
  String name;
  double strength;
  String strengthUnits;
  int unitsPerDosage;
  String reminderFreq;
  int daysInterval;
  List reminderTimes;
  List specificDays;
  List stockReminders;
  int stockNo;

  PrescriptionPopup(this.id, this.name, this.strength, this.strengthUnits, this.unitsPerDosage, this.reminderFreq, this.daysInterval, this.reminderTimes, this.specificDays, this.stockReminders, this.stockNo);

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
                  Text("Strength: " + strength.toString() + strengthUnits),
                  Text("Reminder frequency: " + reminderFreq.toString()),
                  Text("Reminder times: " + reminderTimes.toString()),
                ],
              ),
              flex: 2,
            ),

            // dialog bottom
            Expanded(
              child: Row(
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPrescription(PrescriptionClass(id: id, name: name, strength: strength, strengthUnits: strengthUnits, unitsPerDosage: unitsPerDosage, reminderFreq: reminderFreq, daysInterval: daysInterval, reminderTimes: reminderTimes, specificDays: specificDays, stockReminders: stockReminders, stockNo: stockNo))),
                      );
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      deleteCorrespondingReminders();
                      FirebasePage().deletePrescription(id);
                      Navigator.pop(context);
                      var popUp = PopupAlert("SUCCESS", "Prescription has successfully been deleted");
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context){
                          return popUp;
                        },
                      );
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              )

            ),
          ],
        ),
      ),
    );
  }

  deleteCorrespondingReminders() async {
    //if logged in, show carer's reminders list. else show local device's patients.
    CollectionReference cr = fbUser != null ?
    FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('reminders')
        :
    FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('reminders')
    ;

    QuerySnapshot querySnapshot = await cr.get();

    for(QueryDocumentSnapshot x in querySnapshot.docs){
      if(x.get("prescription") == name && x.get("patientId") == currentPatientID){
        lastSelectedEvents = [];

        // delete the reminder from device with id value of rId
        await flutterLocalNotificationsPlugin.cancel(x.get("id"));
        //delete the reminder from database using the documentId of the reminder in database
        FirebasePage().deleteReminder(cr, x.id);
      }
    }
  }
}
