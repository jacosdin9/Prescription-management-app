import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/prescriptions_files/editPrescriptionInputPopups.dart';
import 'package:project/prescriptions_files/prescriptionClass.dart';

String tempString;
List tempList;
bool tempBool;
int tempInt;

class EditPrescription extends StatefulWidget {

  final data;

  EditPrescription(this.data);

  @override
  _EditPrescriptionState createState() => _EditPrescriptionState(data);
}

class _EditPrescriptionState extends State<EditPrescription> {

  PrescriptionClass data;
  String originalPrescriptionName;
  var locale;

  _EditPrescriptionState(this.data);

  @override
  void initState() {
    super.initState();
    originalPrescriptionName = data.name;

    if(data.silentReminders){
      data.stockNo = updateStockForSilentReminders(data.lastRestockDate, data.unitsPerDosage, data.stockNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Edit Prescription",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Edit Prescription"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: false,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [

                            //General details text
                            Container(
                              height: 20,
                              margin: const EdgeInsets.all(17.0),
                              // color: Colors.black,
                              child: Text(
                                "General details:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),

                            //NAME
                            GestureDetector(
                              onTap: () async {
                                tempString = data.name;

                                var popUp = NameInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.name = tempString;
                                setState(() {});
                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Name: " + data.name),
                              ),
                            ),

                            SizedBox(height: 1),

                            //STRENGTH
                            GestureDetector(
                              onTap: () async {
                                tempString = data.strength.toString();

                                var popUp = StrengthInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.strength = double.parse(tempString);
                                setState(() {});
                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Strength: " + data.strength.toString()),
                              ),
                            ),

                            SizedBox(height: 1),

                            //STRENGTH UNITS
                            GestureDetector(
                              onTap: () async {
                                tempString = data.strengthUnits;

                                var popUp = StrengthUnitsInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.strengthUnits = tempString;
                                setState(() {});
                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Strength Units: " + data.strengthUnits),
                              ),
                            ),

                            SizedBox(height: 1),

                            //UNITS PER DOSAGE
                            GestureDetector(
                              onTap: () async {
                                tempString = data.unitsPerDosage.toString();

                                var popUp = UnitsPerDosageInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.unitsPerDosage = int.parse(tempString);
                                setState(() {});

                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Units Per Dosage: " + data.unitsPerDosage.toString()),
                              ),
                            ),

                            SizedBox(height: 1),

                            //General details text
                            Container(
                              height: 20,
                              margin: const EdgeInsets.all(17.0),
                              // color: Colors.black,
                              child: Text(
                                "Stock details:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),

                            //REMAINING STOCK
                            GestureDetector(
                              onTap: () async {
                                tempString = data.stockNo.toString();
                                tempBool = false;

                                var popUp = RemainingStockInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.stockNo = int.parse(tempString);

                                //if stock no. has been changed, update lastRestockDate to today
                                if(tempBool){
                                  DateTime today = DateTime.now();
                                  data.lastRestockDate = DateTime(today.year, today.month, today.day);
                                }

                                setState(() {});
                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Remaining Stock: " + data.stockNo.toString()),
                              ),
                            ),

                            SizedBox(height: 1),

                            //STOCK REMINDER
                            GestureDetector(
                              onTap: () async {
                                tempString = data.stockReminder.toString();

                                var popUp = StockReminderInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.stockReminder = int.parse(tempString);
                                setState(() {});

                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Stock Reminder: " + data.stockReminder.toString()),
                              ),
                            ),

                            SizedBox(height: 1),

                            //Reminder details text
                            Container(
                              height: 20,
                              margin: const EdgeInsets.all(17.0),
                              // color: Colors.black,
                              child: Text(
                                "Reminder details:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),

                            //REMINDER FREQUENCY
                            GestureDetector(
                              onTap: () async {
                                tempString = data.reminderFreq;

                                var popUp = ReminderFrequencyInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.reminderFreq = tempString;
                                setState(() {});

                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.orange, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Reminder Frequency: " + data.reminderFreq),
                              ),
                            ),

                            SizedBox(height: 1),

                            //SILENT REMINDER
                            GestureDetector(
                              onTap: () async {
                                tempBool = data.silentReminders;

                                var popUp = SilentRemindersInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.silentReminders = tempBool;
                                setState(() {});

                              },
                              child: Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.orange, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Silent Reminders: " + data.silentReminders.toString()),
                              ),
                            ),

                            SizedBox(height: 1),

                            //REMINDER TIMES
                            data.reminderFreq != "None" ?
                            GestureDetector(
                              onTap: () async {
                                tempList = data.reminderTimes;

                                var popUp = ReminderTimesInput();
                                await showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context){
                                    return popUp;
                                  },
                                );

                                data.reminderTimes = tempList;
                                setState(() {});

                              },
                              child:
                                Container(
                                  height: 60,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange, width: 6),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.grey,
                                  ),
                                  child: Text("Reminder Times: " + data.reminderTimes.toString()),
                                )
                              ):SizedBox(height: 0),

                            SizedBox(height: 1),

                            //REMINDER DAYS
                            data.reminderFreq == "Specific days" ?
                            GestureDetector(
                                onTap: () async {
                                  tempList = data.specificDays;
                                  locale = await Localizations.localeOf(context);

                                  var popUp = ReminderDaysInput(locale);
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context){
                                      return popUp;
                                    },
                                  );

                                  data.specificDays = tempList;
                                  setState(() {});

                                },

                              child:
                              Container(
                                height: 60,
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.orange, width: 6),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.grey,
                                ),
                                child: Text("Reminder Days"),
                              )
                            ): SizedBox(height: 0,),

                            //SizedBox(height: 1),
                            //
                            // //DAYS INTERVAL
                            // data.reminderFreq == "Days Interval" ?
                            // GestureDetector(
                            //     onTap: () async {
                            //       tempList = data.reminderTimes;
                            //
                            //       var popUp = ReminderTimesInput();
                            //       await showDialog(
                            //         context: context,
                            //         barrierDismissible: true,
                            //         builder: (BuildContext context){
                            //           return popUp;
                            //         },
                            //       );
                            //
                            //       data.reminderTimes = tempList;
                            //       setState(() {});
                            //
                            //     },
                            //   child:
                            //   Container(
                            //     height: 60,
                            //     margin: const EdgeInsets.all(15.0),
                            //     padding: const EdgeInsets.all(15.0),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.orange, width: 6),
                            //       borderRadius: BorderRadius.all(Radius.circular(20)),
                            //       color: Colors.grey,
                            //     ),
                            //     child: Text("Name: " + data.daysInterval.toString()),
                            //   )
                            // ): SizedBox(height: 0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //BACK BUTTON
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red),
                  ),
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "BACK",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),

                SizedBox(width: 50),

                //DONE BUTTON
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green),
                  ),
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  onPressed: () async {
                    Navigator.pop(context);

                    await FirebasePage().editPrescription(originalPrescriptionName, data);
                    DateTime now = DateTime.now();
                    DateTime today = DateTime(now.year, now.month, now.day);
                    FirebasePage().addRecord(data.name, today, data.stockNo);

                    if(fbUser != null){
                      FirebasePage().updateCarerReminders();
                    }
                  },
                  child: Text(
                    "DONE",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

updateStockForSilentReminders(DateTime lastRestockDate, int unitsPerDosage, int remainingStock){
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  int daysSince = 0;

  while(today.isAfter(lastRestockDate)){
    daysSince += 1;
    today = today.subtract(Duration(days: 1));
    print(today);
  }

  if(daysSince>=1){
    print(remainingStock - (daysSince*unitsPerDosage));
    return remainingStock - (daysSince*unitsPerDosage);
  }

  print("done");
  return remainingStock;
}

