import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/deviceNotification_files/devNotificationPage.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/prescriptions_files/addPrescription.dart';

class ReminderPopup extends StatelessWidget{

  String dbId;
  String freq;
  int rId;
  String patientId;
  String time;
  String day;
  int interval;
  String prescription;

  ReminderPopup(this.dbId, this.freq, this.rId, this.patientId, this.time, this.day, this.interval, this.prescription);

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
                      patientId,
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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 2.0,
              width: 18.0,
              color: Color(0xff00c6ff),
            ),
            // dialog centre
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prescription: " + prescription),
                  Text("Reminder frequency: " + freq),
                  freq == "Specific Day" ? Text("Day: " + findDayStringFromDayValue(int.parse(day))) : Text("Day: Every day"),
                  Text("Time: " + time),
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
                onPressed: () async {

                  // delete the reminder from device with id value of rId
                  await flutterLocalNotificationsPlugin.cancel(rId);

                  //delete the reminder from database using the documentId of the reminder in database
                  FirebasePage().deleteReminder(findRemindersRef(deviceID), dbId);

                  //close reminder popup
                  Navigator.pop(context);

                  //show success popup
                  var popUp = PopupAlert("SUCCESS", "Reminder has successfully been deleted");
                  lastSelectedEvents = [];
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainArea(recentIndex)),
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context){
                      return popUp;
                    },
                  );
                },
                child: Text(
                  "Delete reminder",
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