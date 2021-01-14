import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/patient_files/addExistingPatient.dart';
import 'package:project/prescriptions_files/prescriptions.dart';

class FirebasePage {
  static FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  CollectionReference devicesTable = firestoreDB.collection('devices');

  //ADD PRESCRIPTION
  Future<void> addPrescription(String name, double strength, String units,
      String reminderFreq, List reminderTimes, List specificDays,
      int daysInterval, List stockReminders, int stockNo) {
    CollectionReference prescriptionsTable = findPrescriptionsRef(
        deviceID, currentPatientID);
    return prescriptionsTable.
    add({
      'name': name,
      'strength': strength,
      'units': units,
      'reminderFreq': reminderFreq,
      'reminderTimes': reminderTimes,
      'specificDays': specificDays,
      'daysInterval': daysInterval,
      'stockReminders': stockReminders,
      'stockNo': stockNo,
    }).
    then((value) => print("PRESCRIPTION ADDED")).
    catchError((error) => print("FAILED TO ADD PRESCRIPTION: $error"));
  }

  //DELETE PRESCRIPTION
  Future<void> deletePrescription(String id) {
    CollectionReference prescriptionsTable = findPrescriptionsRef(
        deviceID, currentPatientID);


    return prescriptionsTable.
    doc(id).
    delete().
    then((value) => print("PRESCRIPTION DELETED")).
    catchError((error) => print("FAILED TO DELETE PRESCRIPTION: $error"));
  }

  //CREATE CARER USER
  Future<void> createCarer(String id) {
    CollectionReference carersTable = firestoreDB.collection('carers');
    return carersTable.doc(id).set({}).
    then((value) => print("CARER USER CREATED")).
    catchError((error) => print("FAILED TO CREATE USER: $error"));
  }

  //CREATE LOCAL DEVICE COLLECTION
  Future<void> createDevice(String id) {
    return devicesTable.doc(id).set({}).
    then((value) => print("DEVICE CREATED")).
    catchError((error) => print("FAILED TO CREATE DEVICE: $error"));
  }

  //CREATE LOCAL PATIENT COLLECTION
  Future<void> createPatient(String deviceId, String name, int age,
      double weight, String measurement) {
    CollectionReference patientTable = firestoreDB.collection('devices').doc(
        deviceId).collection('patients');

    return patientTable.add({
      'name': name,
      'age': age,
      'weight': weight,
      'measurement': measurement,
    }).
    then((value) => print("PATIENT CREATED")).
    catchError((error) => print("FAILED TO CREATE PATIENT: $error"));
  }

  //CREATE CONTROLLED PATIENT COLLECTION
  Future<void> createControlledPatient(String carerID, String name, int age,
      double weight, String measurement) {
    CollectionReference controlledPatientTable = firestoreDB.collection(
        'controlledPatients');
    CollectionReference carerTable = firestoreDB.collection('carers').doc(
        fbUser.uid).collection('assignedPatients');

    //create new controlled patient
    var newCP = controlledPatientTable.doc();
    newCP.set({
      'name': name,
      'age': age,
      'weight': weight,
      'measurement': measurement,
      'carers': [carerID],
      'leadCarer': carerID,
    });

    //add new patient ID to carers assignedPatients list
    return carerTable.doc(newCP.id).set({
      'controlled': true,
      'deviceId': "",
    }).
    then((value) => print("CONTROLLED PATIENT CREATED")).
    catchError((error) => print("FAILED TO CREATE CONTROLLED PATIENT: $error"));
  }

  //add existing patient to carer's list of patients.
  //now I need to add carerID to the selected patients list of carers. - issue
  Future<void> addExistingPatient(String deviceId, String patientId,
      String carerId, String notificationId) {
    CollectionReference carerTable = firestoreDB.collection('carers').doc(
        carerId).collection('assignedPatients');
    DocumentReference patientPath;

    //if no deviceId supplied it must be a controlled patient.
    deviceId == "" ?
    patientPath = firestoreDB.collection('controlledPatients').doc(patientId) :
    patientPath = firestoreDB.collection('devices').doc(deviceId)
        .collection('patients')
        .doc(patientId);

    //if patient found in DB, add patientID to carer's patients list
    patientPath.get().
    then((docSnapshot) =>
    {
      if(docSnapshot.exists){
        carerTable.doc(patientPath.id).set({
          'controlled': deviceId == "" ? true : false,
          'deviceId': deviceId,
        }).
        then((value) => print("EXISTING PATIENT ADDED")).
        catchError((error) => print("FAILED TO ADD EXISTING PATIENT: $error")),
        deleteCarerRequest(
            deviceId, patientId, fbUser != null ? fbUser.uid : "",
            notificationId),
      }
      else
        {
          print("PATIENT NOT FOUND")
        }
    });
  }

  Future<void> createCarerRequest(String carer, String device,
      String patient) async {
    String leadCarerId = "";

    //check if carer request is going directly to user, or if it is going to lead carer
    if (device == "") {
      leadCarerId = await findLeadCarerId(device, patient);
    }

    //create path to designated notifications area
    DocumentReference notificationPath = device != "" ?
    FirebaseFirestore.instance.collection('devices').doc(device).collection(
        'patients').doc(patient) :
    FirebaseFirestore.instance.collection('carers').doc(leadCarerId);

    //create path to carer's assignedPatients area so we can check if patient already exists there
    DocumentReference patientExistPath = FirebaseFirestore.instance.collection(
        'carers').doc(carer).collection('assignedPatients').doc(patient);

    //if patient does not already exist in carer's assignedPatient list, add it.
    if (!(await checkIfDocExists(patientExistPath))) {
      //check if patient exists so we can add notification to their profile
      if (await checkIfDocExists(notificationPath)) {
        sent = 1;
        notificationPath.collection('notifications').add({
          'type': "carer_request",
          'carerId': carer,
          'patientId': patient,
        }).then((value) => print("NOTIFICATION CREATED")).
        catchError((error) => print("FAILED TO CREATE NOTIFICATION: $error"));
      }
      else {
        sent = 2;
        print("PATIENT/LEAD CARER NOT FOUND");
      }
    }
    else {
      sent = 3;
      print("PATIENT ALREADY EXISTS IN CARERS ASSIGNED PATIENTS LIST");
    }
  }

  Future<void> deleteCarerRequest(String device, String patient,
      String leadCarerId, String notificationId) {
    DocumentReference notificationPath = device != ""
        ?
    FirebaseFirestore.instance.collection('devices').doc(device).collection(
        'patients').doc(patient).collection('notifications').doc(notificationId)
        :
    FirebaseFirestore.instance.collection('carers').doc(leadCarerId).collection(
        'notifications').doc(notificationId);

    //DocumentReference notificationPath = FirebaseFirestore.instance.collection('devices').doc(device).collection('patients').doc(patient).collection('notifications').doc(notificationId);
    return notificationPath.delete().then((value) =>
        print("NOTIFICATION DELETED")).
    catchError((error) => print("FAILED TO DELETE NOTIFICATION: $error"));
  }

  Future<void> addReminder(String patientId, String pName, int id, String freq,
      String time, String day, int interval) {
    CollectionReference reminderPath = deviceID != "" ?
    FirebaseFirestore.instance.collection('devices').doc(deviceID).collection(
        'reminders') :
    FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection(
        'reminders');

    return reminderPath.doc().set({
      "patientId": patientId,
      "prescription": pName,
      "id": id,
      "frequency": freq,
      "time": time,
      "day": day,
      "interval": interval,
    }).then((value) => print("REMINDER ADDED")).
    catchError((error) => print("FAILED TO CREATE REMINDER: $error"));
  }

  Future<void> deleteReminder(CollectionReference reminderPath, String id) {
    return reminderPath.
    doc(id).
    delete().
    then((value) => print("REMINDER DELETED")).
    catchError((error) => print("FAILED TO DELETE REMINDER: $error"));
  }

  Future<void> findStockToReduce(CollectionReference cr, String prescriptionName) {
    int newStock = 1010101;
    String id = "";
    return cr.get()
        .then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        if (doc["name"] == prescriptionName) {
          //newStock = int.parse(doc["stockNo"]) - int.parse(doc["doseNumber"]);
          id = doc.id;
          reduceStock(cr.doc(id), newStock);
        }
      }),
    });
  }

  Future<void> reduceStock(DocumentReference dr, int newStock) {
    return dr
        .update({'stockNo': newStock})
        .then((value) => print("REMAINING STOCK UPDATED"))
        .catchError((error) => print("FAILED TO UPDATE STOCK: $error"));
  }
}

findLeadCarerId(String device, String patient) async {
    DocumentReference patientReference = FirebaseFirestore.instance.collection('controlledPatients').doc(patient);
    DocumentSnapshot patientRef = await patientReference.get();

    if(patientRef.exists){
      return patientRef.get('leadCarer');
    }
    return null;
}

Future<bool> checkIfDocExists(DocumentReference docRef) async {
  DocumentSnapshot docSnapshot = await docRef.get();
  if(docSnapshot.exists){
    return true;
  }
  return false;
}


Future<int> getReminderIdNo() async {
  CollectionReference reminderPath = deviceID!="" ?
  FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('reminders') :
  FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('reminders');

  QuerySnapshot remSnapshot = await reminderPath.get();
  int currentMax = 0;

  for (QueryDocumentSnapshot x in remSnapshot.docs){
    if(x.get("id") > currentMax){
      currentMax = x.get("id");
    }
  }
  return currentMax+1;
}