import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/objects/prescription.dart';

class FirebasePage {
  static FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  CollectionReference prescriptionsTable = firestoreDB.collection('prescriptions');

  Future<void> addPrescription(Prescription p){
    return prescriptionsTable.
      add({
        'name' : p.name,
        'dosage' : p.dosage,
        'measurement' : p.measurement,
        'noOfReminders' : p.noOfReminders,
        'stock' : p.stock,
      }).
      then((value) => print("PRESCRIPTION ADDED")).
      catchError((error) => print("FAILED TO ADD PRESCRIPTION: $error"));
  }

  Future<void> deletePrescription(String id){
    return prescriptionsTable.
      doc(id).
      delete().
      then((value) => print("PRESCRIPTION DELETED")).
      catchError((error) => print("FAILED TO DELETE PRESCRIPTION: $error"));
  }
}