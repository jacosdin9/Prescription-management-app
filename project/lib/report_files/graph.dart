import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/prescriptions.dart';

class Graph extends StatefulWidget{
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  List<Feature> features;

  @override
  void initState() {
    super.initState();

    findSilentRemindersAndUpdate();

    features = [
      Feature(
        title: "Drink Water",
        color: Colors.blue,
        data: [0.2, 0.8, 1, 0.7,],
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Stock reports"),
        ),
        body: Column(
          children: [
            Text("GRAPH PAGE YEAH"),
            LineGraph(
              features: features,
              size: Size(500, 400),
              labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
              labelY: ['20%', '40%', '60%', '80%', '100%'],
              showDescription: true,
              graphColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

populateFeatures(){
  //retrieve records collection from current patient
  //x_axis = date
  //y_axis = remaining stock
}


findSilentRemindersAndUpdate() async {
  print("running");
  CollectionReference prescriptionsTable = findPrescriptionsRef(deviceID, currentPatientID);

  QuerySnapshot prescriptionsSnapshot = await prescriptionsTable.get();

  //if prescription requires silentReminders, ensure they're updated
  for (QueryDocumentSnapshot x in prescriptionsSnapshot.docs){
    if(x.get('silentReminders') == true){
      await updateSilentRemindersRecords(x.get('name'), x.get('stockNo'), x.get('unitsPerDosage'));
    }
  }

  print("complete");
}

updateSilentRemindersRecords(String pName, int remainingStock, int unitsPerDosage) async {

  //find most recent record for prescription and set to startDate
  CollectionReference recordsPath =
  fbUser == null ?
  FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('records') :
  FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('patients').doc(currentPatientID).collection('records');

  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  DateTime mostRecent = today.subtract(Duration(days: 365));

  QuerySnapshot recordsSnapshot = await recordsPath.get();

  //find most recent record for prescription
  for (QueryDocumentSnapshot x in recordsSnapshot.docs){
    if(x.get('prescriptionName') == pName && (x.get("date") as Timestamp).toDate().isAfter(mostRecent)){
      mostRecent = (x.get("date") as Timestamp).toDate();
    }
  }

  //if prescription records are NOT up-to-date, update them
  if(mostRecent != today){
    //begin updating from day after last recorded day
    mostRecent = mostRecent.add(Duration(days: 1));

    //fill in all dates between that date and today's date
    while(mostRecent.isBefore(today) || mostRecent == today){

      //remove unitsPerDosage from remainingStock every iteration, do not allow it to fall below 0
      remainingStock -= unitsPerDosage;
      if(remainingStock < 0){
        remainingStock = 0;
      }

      //add record to collection
      recordsPath.add({
        "prescriptionName" : pName,
        "date" : mostRecent,
        "stock" : remainingStock,
      }).
      then((value) => print("RECORD ADDED")).
      catchError((error) => print("FAILED TO ADD RECORD: $error"));

      mostRecent = mostRecent.add(Duration(days: 1));
    }
  }
}
