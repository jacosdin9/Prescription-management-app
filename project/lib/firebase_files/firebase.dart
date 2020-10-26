import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/objects/prescription.dart';

class FirebasePage {
  static FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  CollectionReference devicesTable = firestoreDB.collection('devices');

  //ADD PRESCRIPTION
  Future<void> addPrescription(String name, double dosage, String measurement, int noOfReminders, double stock){
    CollectionReference prescriptionsTable = firestoreDB.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('prescriptions');
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
    CollectionReference prescriptionsTable = firestoreDB.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('prescriptions');
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
  Future<void> createPatient(String id, String name, int age, double weight, String measurement){
    CollectionReference patientTable = firestoreDB.collection('devices').doc(id).collection('patients');

    return patientTable.add({
      'name' : name,
      'age' : age,
      'weight' : weight,
      'measurement' : measurement,
    }).

    then((value) => print("PATIENT CREATED")).
    catchError((error) => print("FAILED TO CREATE PATIENT: $error"));
  }


}