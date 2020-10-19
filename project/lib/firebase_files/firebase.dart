import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/objects/prescription.dart';

class FirebasePage {
  static FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  CollectionReference prescriptionsTable = firestoreDB.collection('prescriptions');

  Future<void> addPrescription(String name, double dosage, String measurement, int noOfReminders, double stock){
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

  Future<void> deletePrescription(String id){
    return prescriptionsTable.
      doc(id).
      delete().
      then((value) => print("PRESCRIPTION DELETED")).
      catchError((error) => print("FAILED TO DELETE PRESCRIPTION: $error"));
  }
}