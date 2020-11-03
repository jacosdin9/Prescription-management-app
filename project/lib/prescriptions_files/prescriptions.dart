import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/prescriptionCard.dart';

class PrescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //devices>deviceID - patients>patientID - prescriptions
    //if patient selected, create proper file path. else make a dummy one.
    CollectionReference prescriptionsRef =
    currentPatientID != "" ?
    FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('prescriptions') :
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
        return Row(
          children: [
            Expanded(
              child: new Container(
                color: Colors.white,
                child: new CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    new SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0),
                      sliver: new SliverList(
                        delegate: new SliverChildBuilderDelegate(
                              (context, index) =>
                          new PrescriptionCard(results[index].reference.id, results[index]['name'], results[index]['dosage'], results[index]['measurement'], results[index]['noOfReminders'], results[index]['stock']),
                          childCount: results.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        );
      },
    ) :
    Text("SELECT A PATIENT SO SEE THEIR PRESCRIPTIONS");
  }
}