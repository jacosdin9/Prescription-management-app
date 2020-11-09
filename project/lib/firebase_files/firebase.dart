import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/prescriptions.dart';

class FirebasePage {
  static FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  CollectionReference devicesTable = firestoreDB.collection('devices');

  //ADD PRESCRIPTION
  Future<void> addPrescription(String name, double dosage, String measurement, int noOfReminders, double stock){
    CollectionReference prescriptionsTable = findPrescriptionsRef(deviceID, currentPatientID);
    return prescriptionsTable.
      add({
        'name' : name,
        'dosage' : dosage,
        'measurement' : measurement,
        'noOfReminders' : noOfReminders,
        'stock' : stock,
      }).
      then((value) => print("PRESCRIPTION ADDED")).
      catchError((error) => print("FAILED TO ADD PRESCRIPTION: $error"));
  }

  //DELETE PRESCRIPTION
  Future<void> deletePrescription(String id){
    CollectionReference prescriptionsTable = findPrescriptionsRef(deviceID, currentPatientID);
    return prescriptionsTable.
      doc(id).
      delete().
      then((value) => print("PRESCRIPTION DELETED")).
      catchError((error) => print("FAILED TO DELETE PRESCRIPTION: $error"));
  }

  //CREATE CARER USER
  Future<void> createCarer(String id){
    CollectionReference carersTable = firestoreDB.collection('carers');
    return carersTable.doc(id).set({}).
    then((value) => print("CARER USER CREATED")).
    catchError((error) => print("FAILED TO CREATE USER: $error"));
  }

  //CREATE LOCAL DEVICE COLLECTION
  Future<void> createDevice(String id){
    return devicesTable.doc(id).set({}).
    then((value) => print("DEVICE CREATED")).
    catchError((error) => print("FAILED TO CREATE DEVICE: $error"));
  }

  //CREATE LOCAL PATIENT COLLECTION
  Future<void> createPatient(String deviceId, String name, int age, double weight, String measurement){
    CollectionReference patientTable = firestoreDB.collection('devices').doc(deviceId).collection('patients');

    return patientTable.add({
      'name' : name,
      'age' : age,
      'weight' : weight,
      'measurement' : measurement,
    }).
    then((value) => print("PATIENT CREATED")).
    catchError((error) => print("FAILED TO CREATE PATIENT: $error"));
  }

  //CREATE CONTROLLED PATIENT COLLECTION
  Future<void> createControlledPatient(String carerID, String name, int age, double weight, String measurement){
    CollectionReference controlledPatientTable = firestoreDB.collection('controlledPatients');
    CollectionReference carerTable = firestoreDB.collection('carers').doc(fbUser.uid).collection('assignedPatients');

    //create new controlled patient
    var newCP = controlledPatientTable.doc();
    newCP.set({
      'name' : name,
      'age' : age,
      'weight' : weight,
      'measurement' : measurement,
      'carers' : [carerID],
      'leadCarer' : carerID,
    });

    //add new patient ID to carers assignedPatients list
    return carerTable.doc(newCP.id).set({
      'controlled' : true,
      'deviceId' : "",
    }).
    then((value) => print("CONTROLLED PATIENT CREATED")).
    catchError((error) => print("FAILED TO CREATE CONTROLLED PATIENT: $error"));
  }

  //add existing patient to carer's list of patients.
  //now I need to add carerID to the selected patients list of carers. - issue
  Future<void> addExistingPatient(String deviceId, String patientId, String carerId, String notificationId){
    CollectionReference carerTable = firestoreDB.collection('carers').doc(carerId).collection('assignedPatients');
    DocumentReference patientPath;

    //if no deviceId supplied it must be a controlled patient.
    deviceId == "" ?
    patientPath = firestoreDB.collection('controlledPatients').doc(patientId) :
    patientPath = firestoreDB.collection('devices').doc(deviceId).collection('patients').doc(patientId);

    //if patient found in DB, add patientID to carer's patients list
    patientPath.get().
    then((docSnapshot)=> {
      if(docSnapshot.exists){
        carerTable.doc(patientPath.id).set({
          'controlled' : deviceId == "" ? true : false,
          'deviceId' : deviceId,
        }).
        then((value) => print("EXISTING PATIENT ADDED")).
        catchError((error) => print("FAILED TO ADD EXISTING PATIENT: $error")),
        deleteCarerRequest(deviceId, patientId, fbUser.uid, notificationId),
      }
      else{
        print("PATIENT NOT FOUND")
      }
    });
  }

  Future<void> createCarerRequest(String carer, String device, String patient) async {

    String leadCarerId = "";

    //check if carer request is going directly to user, or if it is going to lead carer
    if(device==""){
      leadCarerId = await findLeadCarerId(device, patient);
    }

    DocumentReference notificationPath = device!="" ?
      FirebaseFirestore.instance.collection('devices').doc(device).collection('patients').doc(patient) :
        FirebaseFirestore.instance.collection('carers').doc(leadCarerId);

    notificationPath.get().
    then((docSnapshot)=> {
      if(docSnapshot.exists){
        notificationPath.collection('notifications').add({
          'type' : "carer_request",
          'carerId' : carer,
          'patientId' : patient,
        }).then((value) => print("NOTIFICATION CREATED")).
        catchError((error) => print("FAILED TO CREATE NOTIFICATION: $error")),
      }
      else{
        print("PATIENT/LEAD CARER NOT FOUND")
      }
    });

  }

  Future<void> deleteCarerRequest(String device, String patient, String leadCarerId, String notificationId){

    DocumentReference notificationPath = device!="" ?
    FirebaseFirestore.instance.collection('devices').doc(device).collection('patients').doc(patient).collection('notifications').doc(notificationId) :
    FirebaseFirestore.instance.collection('carers').doc(leadCarerId).collection('notifications').doc(notificationId);

    //DocumentReference notificationPath = FirebaseFirestore.instance.collection('devices').doc(device).collection('patients').doc(patient).collection('notifications').doc(notificationId);
    return notificationPath.delete().then((value) => print("NOTIFICATION DELETED")).
    catchError((error) => print("FAILED TO DELETE NOTIFICATION: $error"));
  }
}

findLeadCarerId(String device, String patient) async {
    DocumentReference patientReference = FirebaseFirestore.instance.collection('controlledPatients').doc(patient);
    DocumentSnapshot patientRef = await patientReference.get();
    return patientRef.get('leadCarer');
}