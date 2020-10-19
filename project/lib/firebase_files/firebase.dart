import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/objects/prescription.dart';

class FirebasePage {
  FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  CollectionReference prescriptionsTable = FirebaseFirestore.instance.collection('prescriptions');

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


}