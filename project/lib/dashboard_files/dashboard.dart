import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/deviceNotification_files/reminderPopup.dart';
import 'package:project/prescriptions_files/prescriptions.dart';

String patientName = "";
List selectedRemindersList = [];
List patientsRemindersForToday;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    super.initState();

    patientsRemindersForToday = findTodaysDosesForPatient(selectedRemindersList);
    patientsRemindersForToday.sort((a,b) => a.get("time").compareTo(b.get("time")));

    if(currentPatientID != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        patientName = await findPatientNameFromID(deviceID, currentPatientID);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    recentIndex = 1;
    return Center(
      child:
      currentPatientID != "" ?
      Container(
        height: 600,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 6),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey,
        ),
        child: Column(
          children: [
            Text(
              "Today's doses for " + patientName,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            Expanded(
              child: Container(
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                              GestureDetector(
                                onTap: () {
                                  var popUp = ReminderPopup(patientsRemindersForToday[index].id, patientsRemindersForToday[index].get('frequency'), patientsRemindersForToday[index].get('id'), patientsRemindersForToday[index].get('patientId'), patientsRemindersForToday[index].get('time'), patientsRemindersForToday[index].get('day'), patientsRemindersForToday[index].get('interval'), patientsRemindersForToday[index].get('prescription'));
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context){
                                      return popUp;
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent, width: 6),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Text(patientsRemindersForToday[index].get("time") + " - " + patientsRemindersForToday[index].get("prescription")),
                                ),
                              ),
                          childCount: patientsRemindersForToday.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ) :
          Container(
            height: 150,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 6),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "SELECT A PATIENT TO SEE TODAY'S DOSES",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "(You can find the 'Select a patient' option in the drawer",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.menu),
                    Text(
                      ")",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
    );




          // //show current patient id
          // currentPatientID == "" ? Text("NO PATIENT SELECTED") : Text(currentPatientID),
          //
          // //LOCAL NOTIFICATIONS TESTING
          // RaisedButton(
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(18.0),
          //     side: BorderSide(color: Colors.red),
          //   ),
          //   padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
          //   onPressed: () async {
          //     List<PendingNotificationRequest> pendingNotificationRequests;
          //
          //     if(fbUser!=null){
          //       pendingNotificationRequests = await flutterLocalNotificationsPluginOnline.pendingNotificationRequests();
          //     }
          //     else{
          //       pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
          //     }
          //
          //     print("length: " + pendingNotificationRequests.length.toString());
          //     for(var p in pendingNotificationRequests){
          //       print(p.id);
          //     }
          //   },
          //   child: Text(
          //     "Local notification test",
          //     style: TextStyle(
          //       fontSize: 20,
          //     ),
          //   ),
          // ),


  }
}

findTodaysDosesForPatient(List remindersList){

  List todaysReminders = [];
  int today = DateTime.now().weekday;
  DateTime tempDate;
  DateTime todayDateTime = DateTime.now();
  DateTime todayDate = DateTime(todayDateTime.year, todayDateTime.month, todayDateTime.day);

  //if today is Sunday, set to 0 for consistency with firebase
  if(today == 7){
    today = 0;
  }

  for(QueryDocumentSnapshot reminder in remindersList){
    //check if patientID of reminder is same as current patient ID, proceed if so...
    if(currentPatientID == reminder.get("patientId")){

      //if reminder is daily, add to list
      if(reminder.get("frequency") == "Daily"){
        todaysReminders.add(reminder);
      }

      //if reminder has today's weekday selected, add to list
      else if(reminder.get("frequency") == "Specific days" && reminder.get("day") == today.toString()){
        todaysReminders.add(reminder);
      }

      //if reminder is single and has today's date, add to list
      else if(reminder.get("frequency") == "Single"){
        String day = reminder.get("day");
        List daySplit = day.split('/');
        tempDate = DateTime(int.parse(daySplit[2]), int.parse(daySplit[1]), int.parse(daySplit[0]));

        if(tempDate == todayDate){
          todaysReminders.add(reminder);
        }
      }
    }
  }

  return todaysReminders;
}