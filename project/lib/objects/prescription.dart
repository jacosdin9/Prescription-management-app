class Prescription {
  String name;
  double dosage;
  String measurement;
  int noOfReminders;
  int stock;

  Prescription({this.name, this.dosage, this.measurement, this.noOfReminders, this.stock});

  Map<String, dynamic> toMap(){
    return{
      'PrescriptionName' : name,
      'Dosage' : dosage,
      'Measurement' : measurement,
      'NoOfReminders' : noOfReminders,
      'Stock' : stock,
    };
  }
}