import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/prescriptions_files/editPrescription.dart';
import 'package:project/prescriptions_files/prescriptionClass.dart';
import 'package:intl/intl.dart';


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
  int stockReminder;
  int stockNo;
  bool silentReminders;
  DateTime lastRestockDate;

  PrescriptionPopup(this.id, this.name, this.strength, this.strengthUnits, this.unitsPerDosage, this.reminderFreq, this.daysInterval, this.reminderTimes, this.specificDays, this.stockReminder, this.stockNo, this.silentReminders, this.lastRestockDate);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: Container(
        width: 260.0,
        height: 310.0,
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
                  SizedBox(height: 5),
                  Text("Units per dosage: " + unitsPerDosage.toString()),
                  SizedBox(height: 5),
                  Text("Reminder frequency: " + reminderFreq.toString()),
                  SizedBox(height: 5),
                  Text("Stock reminder quantity: " + stockReminder.toString()),
                  SizedBox(height: 5),
                  Text("Silent reminders: " + silentReminders.toString()),
                  SizedBox(height: 5),
                  Text("Last restock date: " + DateFormat('dd-MM-yy').format(lastRestockDate),),
                ],
              ),
              flex: 2,
            ),

            // dialog bottom
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.orange),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditPrescription(PrescriptionClass(id: id, name: name, strength: strength, strengthUnits: strengthUnits, unitsPerDosage: unitsPerDosage, reminderFreq: reminderFreq, daysInterval: daysInterval, reminderTimes: reminderTimes, specificDays: specificDays, stockReminder: stockReminder, stockNo: stockNo, silentReminders: silentReminders, lastRestockDate: lastRestockDate))),
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
                  ),

                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      onPressed: () async {
                        await deleteCorrespondingReminders();
                        await FirebasePage().deletePrescriptionRecords(name);
                        await FirebasePage().deletePrescription(id);
                        if(fbUser != null){
                          FirebasePage().updateCarerReminders();
                        }
                        selectedRemindersList = await downloadRemindersList();
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
    //if logged in, get carer's reminders list. else show local device's patients.
    CollectionReference cr = deviceID == "" ?
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
