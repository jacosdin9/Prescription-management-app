import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/prescriptionCard.dart';

import 'addPrescription.dart';

class PrescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    recentIndex = 2;

    //devices>deviceID - patients>patientID - prescriptions
    //if patient selected, create proper file path. else make a dummy one.
    CollectionReference prescriptionsRef = currentPatientID != "" ?
    findPrescriptionsRef(deviceID, currentPatientID) :
    FirebaseFirestore.instance.collection('devices');

    return
      //if no patient selected, show text. else show patient's overall prescriptions
      currentPatientID != "" ?
      StreamBuilder<QuerySnapshot>(
      stream: prescriptionsRef.snapshots(),
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
                            PrescriptionCard(results[index].reference.id, results[index]['name'], results[index]['strength'], results[index]['strengthUnits'], results[index]['unitsPerDosage'], results[index]['reminderFreq'], results[index]['daysInterval'], results[index]['reminderTimes'], results[index]['specificDays'], results[index]['stockReminder'], results[index]['stockNo'], results[index]['silentReminders'], (results[index]['lastRestockDate'] as Timestamp).toDate()),
                            childCount: results.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red),
                ),
                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                onPressed: () async {
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
              ),
              SizedBox(height: 20),
            ],
          );

      },
    ) :
          Center(
            child: Container(
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
                    "SELECT A PATIENT TO SEE PRESCRIPTIONS HERE",
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

  }
}

CollectionReference findPrescriptionsRef(String deviceID, patientID){
  if(deviceID == ""){
    return FirebaseFirestore.instance.collection('controlledPatients').doc(patientID).collection('prescriptions');
  }
  else{
    return FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(patientID).collection('prescriptions');
  }
}

Future findPatientNameFromID(String deviceID, patientID) async {
  DocumentReference patient;
  if(deviceID == ""){
    patient = FirebaseFirestore.instance.collection('controlledPatients').doc(patientID);
  }
  else{
    patient =  FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(patientID);
  }

  DocumentSnapshot patientQuery = await patient.get();

  return patientQuery.get("name");
}