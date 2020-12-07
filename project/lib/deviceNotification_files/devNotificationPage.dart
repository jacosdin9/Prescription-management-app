import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/deviceNotification_files/reminderPopup.dart';
import 'package:project/main_backend/mainArea.dart';

class DevNotificationPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    //if logged in, show carer's assignedPatients list. else show local device's patients.
    CollectionReference remindersList = fbUser != null ?
    FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('reminders')
        :
    FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('reminders')
    ;


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Reminders"),
        ),
          body: StreamBuilder<QuerySnapshot>(
              stream: remindersList.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                //IF THERE'S AN ERROR:
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                //LOADING STATE:
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var results = snapshot.data.docs;

                //PRINT DATABASE CONTENTS
                return
                  Column(
                      children: [
                        //If no reminders created yet, display text("NONE"). Else display reminders
                        results.length != 0 ?
                        Expanded(
                          child: Container(
                            child: CustomScrollView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: false,
                              slivers: <Widget>[
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) =>
                                          GestureDetector(
                                            onTap: () {
                                              var popUp = ReminderPopup(results[index].id, results[index].get('frequency'), results[index].get('id'), results[index].get('patientId'), results[index].get('time'), results[index].get('day'), results[index].get('interval'), results[index].get('prescription'));
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context){
                                                  return popUp;
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 30,
                                              margin: EdgeInsets.symmetric(vertical: 8.0),
                                              color: Colors.grey,
                                              child: Text(results[index].id),
                                            ),
                                          ),
                                      childCount: results.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) :
                        Text("NO REMINDERS SET"),

                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red),
                          ),
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainArea(recentIndex)),
                            );
                          },
                          child: Text(
                            "BACK",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ]
                  );
              }
          ),
        ),
      );
  }

}

CollectionReference findRemindersRef(String deviceID){
  if(deviceID == ""){
    return FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('reminders');
  }
  else{
    return FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('reminders');
  }
}