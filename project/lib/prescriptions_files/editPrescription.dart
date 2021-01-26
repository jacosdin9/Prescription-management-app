import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/prescriptions_files/prescriptionClass.dart';


class EditPrescription extends StatefulWidget {

  final data;

  EditPrescription(this.data);

  @override
  _EditPrescriptionState createState() => _EditPrescriptionState(data);
}

class _EditPrescriptionState extends State<EditPrescription> {

  PrescriptionClass data;
  String originalPrescriptionName;

  _EditPrescriptionState(this.data);

  @override
  void initState() {
    super.initState();
    originalPrescriptionName = data.name;
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
                            //NAME
                            GestureDetector(
                              onTap: () {
                                data.name = "remEditTest";
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Name: " + data.name),
                              ),
                            ),

                            SizedBox(height: 5),

                            //STRENGTH
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Strength: " + data.strength.toString()),
                              ),
                            ),

                            SizedBox(height: 5),

                            //STRENGTH UNITS
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Strength Units: " + data.strengthUnits),
                              ),
                            ),

                            SizedBox(height: 5),

                            //UNITS PER DOSAGE
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Units Per Dosage: " + data.unitsPerDosage.toString()),
                              ),
                            ),

                            SizedBox(height: 5),

                            //STOCK REMINDERS
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Stock Reminders: "),
                              ),
                            ),

                            SizedBox(height: 5),

                            //REMAINING STOCK
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Remaining Stock: " + data.stockNo.toString()),
                              ),
                            ),

                            SizedBox(height: 5),

                            //REMINDER FREQUENCY
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Reminder Frequency: " + data.reminderFreq),
                              ),
                            ),

                            SizedBox(height: 5),

                            //REMINDER DAYS
                            GestureDetector(
                              onTap: () {

                              },
                              child: data.reminderFreq == "Specific days" ?
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Reminder Days"),
                              ) : SizedBox(),
                            ),

                            SizedBox(height: 5),

                            //DAYS INTERVAL
                            GestureDetector(
                              onTap: () {

                              },
                              child: data.reminderFreq == "Days Interval" ?
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Name: " + data.daysInterval.toString()),
                              ) : SizedBox(height: 0),
                            ),

                            SizedBox(height: 5),

                            //REMINDER TIMES
                            GestureDetector(
                              onTap: () {

                              },
                              child: data.reminderFreq != "None" ?
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 25.0),
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: Text("Reminder Times"),
                              ) :SizedBox(height: 0),
                            ),

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
                    FirebasePage().editPrescription(originalPrescriptionName, data);
                    Navigator.pop(context);
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