import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:intl/intl.dart';

DateTime now = DateTime.now();
DateTime today = DateTime(now.year, now.month, now.day);
String tempDevID = deviceID.substring(0, deviceID.length);

class Graph extends StatefulWidget{
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {

  List<Feature> features;
  List<String> xAxis = [];
  List<String> yAxis = [];
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    features = [];
    selectedDate = today;

    findSilentRemindersAndUpdate(today);

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
              labelX: xAxis,
              labelY: ['20.0', '40.0', '60.0', '80.0', '100.0'],
              showDescription: true,
              graphColor: Colors.red,
            ),
            SizedBox(height: 50,),
            RaisedButton(
              onPressed: () => _selectDate(context), // Refer step 3
              child: Text(
                'Select date\n     ' + DateFormat('dd-MM').format(selectedDate),
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      findSilentRemindersAndUpdate(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  findSilentRemindersAndUpdate(DateTime date) async {
    print("running");

    if(fbUser != null){
      tempDevID = await findPatientsDeviceID(currentPatientID);
    }

    CollectionReference prescriptionsTable = FirebaseFirestore.instance.collection('devices').doc(tempDevID).collection('patients').doc(currentPatientID).collection('prescriptions');

    //create x axis - dates of past 7 days

    DateTime firstDateOfWeek = findFirstDateOfTheWeek(date);
    DateTime lastDateOfWeek = findLastDateOfTheWeek(date);
    String formattedDate;

    List dates = [];
    xAxis = [];

    while(firstDateOfWeek.isBefore(lastDateOfWeek) || firstDateOfWeek == lastDateOfWeek){
      formattedDate = DateFormat('dd-MM').format(firstDateOfWeek);
      dates.add(firstDateOfWeek);
      xAxis.add(formattedDate);
      firstDateOfWeek = firstDateOfWeek.add(Duration(days: 1));
    }

    QuerySnapshot prescriptionsSnapshot = await prescriptionsTable.get();
    List<String> prescriptionList = [];

    //if prescription requires silentReminders, ensure they're updated
    for (QueryDocumentSnapshot x in prescriptionsSnapshot.docs){
      prescriptionList.add(x.get('name'));
      if(x.get('silentReminders') == true){
        await updateSilentRemindersRecords(x.get('name'), x.get('stockNo'), x.get('unitsPerDosage'));
      }
    }

    features = await populateFeatures(prescriptionList, dates);

    setState(() {});
    print("complete");
  }
}

populateFeatures(List<String> prescriptionList, List dates) async {
  //retrieve records collection from current patient
  CollectionReference recordsPath = FirebaseFirestore.instance.collection('devices').doc(tempDevID).collection('patients').doc(currentPatientID).collection('records');

  List<Color> colors = [Colors.red, Colors.blue, Colors.yellow, Colors.orange, Colors.green, Colors.black, Colors.grey, Colors.purple, Colors.tealAccent, Colors.brown];
  int originalStock = 0;

  //order collection by date
  Query recordsPathOrdered = recordsPath.orderBy('date');

  Map recordDict = Map();
  List<Feature> features = [];
  List<double> newList = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  QuerySnapshot recordsSnapshot = await recordsPathOrdered.get();

  print(dates);

  for (QueryDocumentSnapshot x in recordsSnapshot.docs){
    //if prescription name not already in dictionary, create a fresh list
    recordDict.putIfAbsent(x.get('prescriptionName'), () => List<double>.from(newList));

    //find index of x-axis to insert record's stock value by using date
    int index = dates.indexOf((x.get("date") as Timestamp).toDate());

    //if date does not exist within specified range, do not add to dictionary
    if(index != -1){
      recordDict[x.get('prescriptionName')][index] = x.get('stock').toDouble() / 100;
    }
  }

  //remove 0s from end of lists in dictionary
  // if end value == 0.0, remove it.
  // Do this until value is not 0.0.
  bool removingEnd = true;
  for(String name in recordDict.keys){
    for(int i = 6; i>0; i--){
      if(removingEnd && recordDict[name][i] == 0.0){
        recordDict[name].removeAt(i);
      }
      else{
        break;
      }
    }

    // Then other 0.0s between values should become the previous value to prevent random dips to 0.
    // (accounts for days being skipped and stock not going down)
    for(int i = recordDict[name].length-1; i>0; i--){
      if(recordDict[name][i] == 0.0){
        recordDict[name][i] = recordDict[name][i-1];
      }
    }
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
      print("Colours limit exceeded");
      break;
    }
  }

  print(recordDict);
  return features;
}

updateSilentRemindersRecords(String pName, int remainingStock, int unitsPerDosage) async {

  CollectionReference recordsPath = FirebaseFirestore.instance.collection('devices').doc(tempDevID).collection('patients').doc(currentPatientID).collection('records');

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

// Find the first date of the week which contains the provided date.
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

// Find last date of the week which contains provided date.
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}