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

    // features = [
    //   Feature(
    //     title: "Drink Water",
    //     color: Colors.blue,
    //     data: [0.2, 0.8, 1, 0.7,],
    //   ),
    // ];
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
              labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7', 'Day 8'],
              labelY: ['20.0', '40.0', '60.0', '80.0', '100.0'],
              showDescription: true,
              graphColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  findSilentRemindersAndUpdate() async {
    print("running");
    CollectionReference prescriptionsTable = findPrescriptionsRef(deviceID, currentPatientID);

    QuerySnapshot prescriptionsSnapshot = await prescriptionsTable.get();

    List<String> prescriptionList = [];

    //if prescription requires silentReminders, ensure they're updated
    for (QueryDocumentSnapshot x in prescriptionsSnapshot.docs){
      prescriptionList.add(x.get('name'));
      if(x.get('silentReminders') == true){
        await updateSilentRemindersRecords(x.get('name'), x.get('stockNo'), x.get('unitsPerDosage'));
      }
    }

    features = await populateFeatures(prescriptionList);


    setState(() {});
    print("complete");
  }

}

populateFeatures(List<String> prescriptionList) async {
  //retrieve records collection from current patient
  CollectionReference recordsPath =
  fbUser == null ?
  FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('records') :
  FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('patients').doc(currentPatientID).collection('records');

  List<Color> colors = [Colors.red, Colors.blue, Colors.yellow, Colors.orange, Colors.green, Colors.black, Colors.grey, Colors.purple, Colors.tealAccent, Colors.brown];

  //order collection by date
  Query recordsPathOrdered = recordsPath.orderBy('date');

  Map recordDict = Map();

  List<Feature> features = [];

  // features = [
  //   Feature(
  //     title: "Drink Water",
  //     color: Colors.blue,
  //     data: [0.2, 0.8, 1, 0.7,],
  //   ),
  // ];

  QuerySnapshot recordsSnapshot = await recordsPathOrdered.get();

  for (QueryDocumentSnapshot x in recordsSnapshot.docs){
    //if prescription name not already in dictionary, create a fresh list
    recordDict.putIfAbsent(x.get('prescriptionName'), () => List<double>());

    recordDict[x.get('prescriptionName')].add(x.get('stock').toDouble() / 100);
  }

  int colorCounter = 0;
  //populate features using recordDict
  for(String name in recordDict.keys){
    features.add(
      Feature(
        title: name,
        color: colors[colorCounter],
        data: recordDict[name],
      )
    );

    colorCounter += 1;

    if(colorCounter > colors.length){
      colorCounter = 0;
    }
  }

  print(recordDict);

  return features;
}

updateSilentRemindersRecords(String pName, int remainingStock, int unitsPerDosage) async {

  CollectionReference recordsPath =
  fbUser == null ?
  FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('records') :
  FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('patients').doc(currentPatientID).collection('records');

  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  //find most recent record for prescription and set to startDate
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
