import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/prescriptions.dart';
import 'addExistingPatient.dart';
import 'createUser.dart';

class ChangeUserPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    //if logged in, show carer's assignedPatients list. else show local device's patients.
    CollectionReference patientsIdList = fbUser != null ?
    FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('assignedPatients')
        :
    FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients')
    ;

    popMethod(){
      Navigator.pop(context);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Switch user"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: patientsIdList.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

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
                  //If no patients created yet, ask user to create one. Else display users
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
                                      onTap: () async {
                                        currentPatientID = results[index].id;
                                        selectedRemindersList = await downloadRemindersList();
                                        lastSelectedEvents = [];
                                        if(fbUser!=null){
                                          deviceID = results[index].get('deviceId');
                                        }
                                        popMethod();
                                      },
                                      child: Container(
                                        height: 60,
                                        margin: const EdgeInsets.all(15.0),
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueAccent, width: 6),
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          color: Colors.grey,
                                        ),
                                        child: fbUser != null ?
                                          Text(findPatientNameFromID(results[index].get("deviceId"), results[index].id).toString()) :
                                          Text(results[index].get("name")),
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
                      Text("NO USERS FOUND"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fbUser != null ?
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddExistingPatient()),
                          );
                        },
                        child: Text(
                          "ADD EXISTING PATIENT",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ) :
                      SizedBox(height:0),

                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateUser()),
                          );
                        },
                        child: Text(
                          "CREATE USER",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),

                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red),
                        ),
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                        onPressed: () {
                          popMethod();
                        },
                        child: Text(
                          "BACK",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ]
              );
          }
        ),
      ),
    );
  }
}