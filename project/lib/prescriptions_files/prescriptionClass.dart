class PrescriptionClass{
  String id;
  String name;
  double strength;
  String strengthUnits;
  int unitsPerDosage;
  String reminderFreq;
  int daysInterval;
  List reminderTimes;
  List specificDays;
  int stockReminder;
  int stockNo;

  PrescriptionClass({this.id, this.name, this.strength, this.strengthUnits, this.unitsPerDosage, this.reminderFreq, this.daysInterval, this.reminderTimes, this.specificDays, this.stockReminder, this.stockNo});
}